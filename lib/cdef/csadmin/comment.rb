module Cdef
  module CsAdmin
    class Comment < Cdef::CsAdmin::Base
      p "loading  class Comment < Cdef::CsAdmin::Base"

      get '/' do 
        p 'getting add comment'
        @title = 'Add Comment'
        haml :comment
      end

      post '/' do 
        resource = rest_resource + "/" + action_name

        params[:account_id] = current_user.id
        params[:sale_id] = current_sale_id
        @comments = submit(current_user.username, 'POST', resource, current_user.api_key, params.to_json)

        @title = 'Add Comment'
        # Need friendly name hence not using action_name
        @action = 'comment'
        if @comments.include?("exception")
          @status = "Failure"
        else
          @status = "Success"
        end

        haml :message
      end


    end
  end
end
