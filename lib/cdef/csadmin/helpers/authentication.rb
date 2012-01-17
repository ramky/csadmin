require 'rubygems'
require 'sinatra/base'

module Sinatra
  module CsAdminAuthentication
    module Helpers

      def current_user
        user = nil
        if session[:user]
          user = Cdef::Models::Account.get(session[:user])
        end
        user
      end

      def current_roles
        Cdef::Models::AccountRole.
          all(:account_id => current_user.id).roles.map(&:name)
      end

      def current_order
        session[:order]
      end
      
      def current_order_id
        current_order && current_order['order_id']
      end

      def current_sale_id
        current_order && current_order['sale_id']
      end

      def current_email
        current_order && current_order['email']
      end

      def user_authentic?(username, password)
        acc = Cdef::Models::Account.first(:username => username)
        return nil unless acc
        return acc if acc.authentic?(password)
      end 

      def login_required
        if request.path =~ %r{/sass/[-\w/]+\.css|/login|/logout}
          true
        else
          if session[:user]
            false
          else
            session[:return_to] = request.fullpath
            redirect '/login'
            true
          end 
        end 
      end 

      def logged_in?
        !!session[:user]
      end
    end # module helpers
    def self.registered (app)
      app.helpers CsAdminAuthentication::Helpers
    end 

  end # module CsAdminAuthentication

  register CsAdminAuthentication
end
