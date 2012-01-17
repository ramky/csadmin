require 'rubygems'
require 'cdef/configuration'

module Cdef
  module CsAdmin
    class Configuration
      include Cdef::Configuration
      configure :cs_admin
    end 
  end 
end 
