require 'cdef/models'
require 'cdef/security'
require 'json'
require 'sinatra/base'
require 'cdef/csadmin/helpers'
require 'haml'
require 'sass'
require 'pathname'
require 'rack-flash'
require 'memcache'

module Cdef
  module CsAdmin
    class Base < Sinatra::Base
      use Rack::MethodOverride
      register Sinatra::CdefRestRequest
      register Sinatra::CsAdminAuthentication
      helpers Sinatra::ViewHelper
      helpers Sinatra::HamlPartials

      set :static, true
      set :public, 'public'

      @@config = Cdef::CsAdmin::Configuration.new 
      domain          = @@config.domain || '127.0.0.1'
      memcache_server = @@config.memcache_server || '127.0.0.1'
      memcache_port   = @@config.memcache_port || '11211'
      memcache_key    = @@config.memcache_key
      expire_after    = @@config.expire_after

      use Rack::Session::Memcache, :key              => memcache_key, 
                                   :memcache_server  => "#{memcache_server}:#{memcache_port}",
                                   :domain           => domain,
                                   :expire_after     => expire_after 
      use Rack::Flash

      @@cache = MemCache.new "#{memcache_server}:#{memcache_port}", :namespace => 'cdef'
      pt = Cdef::Models::ProductType
      product_types = pt.all
      hash_of_product_types = Hash.new
      pt.all.each do |product|
        hash_of_product_types["#{product[:code]}"] = product[:name]
      end 
      hash_of_product_types
      @@cache.add('product_codes', hash_of_product_types)

      before do
        login_required
      end

      # generate from sass if css not in static dir.
      get /(.+)\.css/ do
        content_type 'text/css', :charset => 'utf-8'
        sass params[:captures].first.to_sym
      end

      def build_memcache
        add_product_types_to_memcache(@@cache)
      end

      def get_product_types_from_memcache
        @@cache.get('product_codes')
      end

      def action_name
        self.class.name.gsub(%r{\A.*::},'').downcase
      end

      def rest_resource
        "#{@@config.rest_server_protocol}:\/\/#{@@config.rest_server}:#{@@config.rest_server_port}"
      end
   end
  end
end
