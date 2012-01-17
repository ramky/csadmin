require 'rubygems'
require 'sinatra/base'
require 'base64'
require 'net/http'
require 'openssl'
require 'time'
require 'uri'
require 'cdef/common'
require 'json'
require 'pp'

#include Cdef::Common::SysExits

# = Sinatra::CdefRestRequest
module Sinatra
  module CdefRestRequest
    module Helpers

      def submit(user, method, resource, key, payload)
        uri = get_uri(resource)
        uri_path = (uri.path || '' ) + (uri.query.nil? ? '' : '?' + uri.query)
        begin
          case method
          when "POST":
            req = Net::HTTP::Post.new(uri_path)
            set_payload(req, payload)
          when "GET":
            req = Net::HTTP::Get.new(uri_path)
          when "PUT":
            req = Net::HTTP::Put.new(uri_path)
            set_payload(req, payload)
          when "DELETE":
            req = Net::HTTP::Delete.new(uri_path)
          end
          req['Accept'] = 'application/json'
          set_authorization(user, method, uri, req, key)
          res = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(req) }
          unless res.body.empty?
            # ActiveSupport breaks JSON.pretty_generate so we can't use it
            return JSON.parse(res.body)
          end
          
          err = "error: response body is empty '#{uri.to_s}'"
          return error(err)

        rescue Errno::ECONNREFUSED 
          err = "error: connection refused '#{uri.to_s}'"
          return error(err)
        rescue SocketError => e
          err = e.to_s
          if $!.message =~ /getaddrinfo: Name or service not known/
            err = "error: connection refused '#{uri.to_s}'"
          end
          return error(err)
        rescue Exception => e
          err = "error: #{e.class}: #{e.message}"
          return error(err)
        end
      end

      private
      def error (e)
        puts e
        "{:exception => {code => 500, :msg => #{e}}}"
      end

      def get_uri(resource)
        begin
          uri = URI.parse resource
          unless uri.scheme == 'http'
            err =  "error: unsupported protocol #{uri.scheme}, please use http instead"
            return error(err)  
          end
        rescue URI::InvalidURIError
          err = "error: malformed URI: #{resource}"
          return error(err)  
        rescue Exception => e
          err = "error: #{e.class}: #{e.message}"
          return error(err)  
        end
        return uri
      end

      def set_payload (req, payload)
        req.content_type = 'application/json';
        if payload
          req.content_length = payload.bytesize
          req.body = payload
        else
          req.content_length = 0
        end
        req
      end

      def set_authorization (user, method, uri, req, key)
        date                 = Time.now.httpdate
        signature_data       = "#{user}\n#{method}\n#{uri.path}\n#{date}"
        digest               = OpenSSL::Digest.new 'sha256'
        signature            = OpenSSL::HMAC.hexdigest(digest, key, signature_data).to_s
        credentials          = Base64.encode64("#{user}:#{signature}").gsub "\n", ''
        req['Date']          = date
        req['Authorization'] = "CDEF #{credentials}"
        req
      end
    end # module Helpers

    def self.registered (app)
      app.helpers CdefRestRequest::Helpers
    end 
  end # module CdefRestRequest

  register CdefRestRequest
end
