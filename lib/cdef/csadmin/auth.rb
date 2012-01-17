module Cdef
  module CsAdmin
    class Auth < Cdef::CsAdmin::Base
      p "loading Auth < Cdef::CsAdmin::Base"

      get '/' do 
        @title = 'View Authorization Details'
        haml :auth
      end

      post '/' do 
        pp params
        @transactions = []
        resource = rest_resource + "/customers/#{params[:search_string]}/transactions"  

        response = submit(current_user.username, 
                         'GET', resource, 
                         current_user.api_key, params.to_json)

        unless response.include?('exception')
          @transactions = response['transactions']
        end
        haml :auth_results, :layout => false
      end
    end
  end
end
