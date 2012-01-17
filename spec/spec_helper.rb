require 'rubygems'
require 'sinatra'
require 'faker'
require 'pp'
require 'rack'

ENV['CDEF_ENV'] = 'test'

require 'cdef/models'
require 'cdef/csadmin'
ENV['ADAPTER'] ||= 'mysql'

require 'dm-core/spec/setup'
require 'dm-core/spec/lib/spec_helper'
require 'dm-core/spec/lib/adapter_helpers'
require 'dm-core/spec/lib/pending_helpers'
require 'rack/test'
require 'test/unit/assertions'
include Test::Unit::Assertions


module Rack
  module Test
    DEFAULT_HOST='127.0.0.1'
  end
end

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each do |file|
  require File.expand_path(file)
end

Spec::Runner.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
  config.include(DataMapper::Spec::PendingHelpers)
  config.include(DataMapper::Spec::Helpers)
  config.include Rack::Test::Methods

  config.before :suite do
    Sinatra::Base.descendants.each do |app|
      app.set :environment, :test
    end
  end

  config.before :each do
    #DataMapper::Model.descendants.to_a.reverse.each(&:destroy!)
    #DataMapper.send(:repository_execute, :auto_migrate_up_constraints!, nil)
  end
end
