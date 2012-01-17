module Cdef
  module CsAdmin
    class License < Cdef::CsAdmin::Base
      @title = "License"

      get '/' do 
        ssi_id = current_ssi_id.split('.').first
        p "ssi_id: #{ssi_id}"
        resource = rest_resource + "/" + "license/#{ssi_id}" 
        response = submit(current_user.username, 
                'GET', resource, 
                current_user.api_key, params.to_json)

        if response.include?("exception")
          puts "Error"
          flash[:notice] = "Error"
        end

        @license = response['license']
        p 'License: '
        pp @license

        p "act: #{@license['act_code']}"
        #this should never happen
        if @license.nil?
          flash[:notice] = "License information doesn't exit"
        end

        haml :'license/show'
      end

      post '/:id' do 
        p '*'*100
        #ssi_id = current_ssi_id.split('.').first
        #p "ssi_id: #{ssi_id}"
        #resource = rest_resource + "/" + "license/#{ssi_id}" 
        #response = submit(current_user.username, 
        #        'GET', resource, 
        #        current_user.api_key, params.to_json)

        #if response.include?("exception")
        #  puts "Error"
        #  flash[:notice] = "Error"
        #end

        #@license = response['license']
        #p 'License: '
        #pp @license

        #p "act: #{@license['act_code']}"
        ##this should never happen
        #if @license.nil?
        #  flash[:notice] = "License information doesn't exit"
        #end

        #haml :'license/show'
      end

    end
  end
end
