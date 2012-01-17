require 'cdef/common'
require 'cdef/configuration'

module Cdef
  module CsAdmin
    class Configuration
      include Cdef::Configuration
      configure :cs_admin, :default => {
        :host => '0.0.0.0',
        :lockfile_dir => '/var/log/cyberdefender/lock',
        :pidfile_dir => '/var/log/cyberdefender/run',
      }, :required => ['port']

      def pidfile
        "#{ pidfile_dir }/#{ File.basename($0) }.pid"
      end
      alias_method :pid_file, :pidfile

      def lockfile
        "#{ lockfile_dir }/#{ File.basename($0) }"
      end

    end 
  end 
end 
