module Cdef
  module CsAdmin
    class Root < Cdef::CsAdmin::Base
      p 'before calling root'
      get '/?' do 
        redirect '/search'
      end
    end
  end
end
