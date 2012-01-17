require 'spec_helper'

describe Cdef::CsAdmin::Login do
  describe "post" do
    it "should authenticate and redirect to search" do
      # app is defined in ../support/route.rb
      browser = Rack::Test::Session.new(Rack::MockSession.new(app))
      browser.post '/login', {:username => 'tester', :password => 'password1'}
      browser.get '/search'
      assert browser.last_response.body.include?('Welcome')
    end
  end
end
require 'spec_helper'

describe Cdef::CsAdmin::Search do
  describe "get" do
    it "should redirect to /login when not logged in" do
      get '/search'
      last_response.location == 'http://127.0.0.1/login'
    end
  end
end
