def app 
  Rack::Builder.new{
    map '/' do
        run ::Cdef::CsAdmin::Root
    end 

    map '/login' do
        run ::Cdef::CsAdmin::Login
    end 

    map '/logout' do
        run ::Cdef::CsAdmin::Logout
    end 

    map '/search' do
        run ::Cdef::CsAdmin::Search
    end 
  }.to_app
end

