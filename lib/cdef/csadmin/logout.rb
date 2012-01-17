module Cdef
  module CsAdmin
    class Logout < Cdef::CsAdmin::Base
      p "before calling logout"
      get '/' do 
        p 'getting logout'
        session.delete(:user)
        session.delete(:order)

        redirect '/login'
      end

    end # class Logout
  end # module CsAdmin
end
