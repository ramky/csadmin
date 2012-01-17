
module Cdef
  module CsAdmin
    class Search < Cdef::CsAdmin::Base
      get '/' do 
        @title = 'Search'
        if params[:rnt_customer_id]
          @rnt_customer_id = params[:rnt_customer_id]
          resource = rest_resource + "/" + action_name
          params[:search_type] = 'rnt'

          @orders = submit(current_user.username, 
                           'POST', resource, 
                           current_user.api_key, params.to_json)

          haml :rnt_search_results
        else
          haml :search
        end
      end

      get '/rnt/?' do 
        @title = "Search Results"
      end

      post '/' do
        @title = "Search Results"
        resource = rest_resource + "/" + action_name

        @orders = submit(current_user.username, 
                         'POST', resource, 
                         current_user.api_key, params.to_json)

        haml :search_results, :layout => false
      end
    end
  end
end
