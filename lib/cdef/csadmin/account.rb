module Cdef
  module CsAdmin
    class Account < Cdef::CsAdmin::Base
      get '/' do 
        resource = rest_resource + "/" + 'accounts'
        @accounts = submit(current_user.username, 
                'GET', resource, 
                current_user.api_key, params.to_json)

        if @accounts.include?("exception")
          puts "Error"
          flash[:notice] = "Error"
        end
        haml :'accounts/index'
      end
      
      get '/:id/edit' do 
        @disable_admin = false
        resource = rest_resource + "/" + "account/#{params[:id]}/edit" 
        response = submit(current_user.username, 
                'GET', resource, 
                current_user.api_key, params.to_json)

        if response.include?("exception")
          puts "Error"
          flash[:notice] = "Error"
        end

        @account = response['account']
        #this should never happen
        if @account.nil?
          flash[:notice] = "User information doesn't exit"
          redirect '/accounts'
          return
        end
        @disable_admin = true if current_user.id.eql?(@account['id'].to_i)

        haml :'accounts/edit'
      end

      get '/new' do 
        @title = 'Create New Account'
        resource = rest_resource + "/" + "accounts/new" 
        response = submit(current_user.username, 
                'GET', resource, 
                current_user.api_key, params.to_json)

        if response.include?("exception")
          puts "Error"
          flash[:notice] = "Error"
        end

        @roles = response['roles']

        haml :'accounts/new'
      end

      post '/:id/update' do 
        params["current_user_id"] = current_user.id

        resource = rest_resource + "/" + "account/#{params[:id]}/update" 
        response = submit(current_user.username, 
                'POST', resource, 
                current_user.api_key, params.to_json)

        if response.include?("exception")
          puts "Error: #{response['exception']['message']}"
          flash[:notice] = "Couln't update account information"
        end

        redirect '/accounts'
      end

      post '/' do 
        resource = rest_resource + "/" + "accounts"
        response = submit(current_user.username, 
                'POST', resource, 
                current_user.api_key, params.to_json)

        p 'response: '
        pp response
        if response.include?("exception")
          puts "Error: #{response['exception']['message']}"
          flash[:notice] = "Couln't create account : #{response['exception']['message']}"
          redirect '/accounts/new'
        else 
          redirect '/accounts'
        end
      end

      delete '/delete/:id' do 
        p "1"*100
        resource = rest_resource + "/" + "accounts/delete/#{params[:id]}"
        response = submit(current_user.username, 
                'POST', resource, 
                current_user.api_key, params.to_json)

        p 'response: '
        pp response
        if response.include?("exception")
          puts "Error: #{response['exception']['message']}"
          flash[:notice] = "Couln't create account : #{response['exception']['message']}"
        end

        redirect '/accounts'
      end
    end
  end
end
