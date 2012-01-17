require 'rubygems'
require 'active_support/all'
#require 'cdef/logger'
require 'cdef/csadmin/configuration'

# need extensions before others
#require 'cdef/rest/extensions'

module Cdef
  module CsAdmin
    extend self

    # See Cdef::Rest::Configuration for the default configuration file path
    # and the format.
    attr_accessor_with_default(:configuration){ @configuration ||= Cdef::CsAdmin::Configuration.new }
  end
end

# Set logging based on CDEF_ENV
#if ENV['CDEF_ENV'] == 'development'
#  Cdef.logger.level = ::Logger::DEBUG
#else
#  Cdef.logger.level = ::Logger::WARN
#end

# Load all libraries under cdef/rest/*
dir = __FILE__[%r{\A(?:(?:.*/)?lib/|\./)?(.*)\.rb\z}, 1]
files = Dir[File.join(__FILE__[%r{\A(.*)\.rb\z}, 1], '*.rb')]


# base.rb must come first
base_file = files.grep(/base\.rb\z/).first
files.delete(base_file)
require base_file


#  now the rest
files.sort.each do |lib|
  require "#{ dir }/#{ File.basename(lib) }"
end
