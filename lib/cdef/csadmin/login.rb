module Cdef
  module CsAdmin
    class Login < Cdef::CsAdmin::Base
      p "before calling login"
      get '/' do 
        p 'getting login'
        @title = 'Login'
        haml :login
      end

      post '/' do
        if user = user_authentic?(params[:username], params[:password]) 
          session[:user] = user.id
          puts "session[:return_to]"
          puts session[:return_to]
          if session[:return_to] 
            redirect_url = session[:return_to] 
            session[:return_to] = false
            redirect redirect_url
          else
            redirect '/'
          end
        else
          flash[:notice] = "The email or password you entered is incorrect."
          redirect '/login'
        end
      end

    end # class Login
  end # module CsAdmin
end
