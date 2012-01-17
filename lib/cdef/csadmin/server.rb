require 'lockfile'
require 'fileutils'
require 'forwardable'
require 'cdef/csadmin/configuration'
module Cdef
  module CsAdmin
    class Server

      class << self

        def run(options={})
          Cdef.logger.log_error do
            my_pid = $$
            FileUtils.mkdir_p(Cdef::CsAdmin.configuration.lockfile_dir)
            FileUtils.mkdir_p(Cdef::CsAdmin.configuration.pidfile_dir)
            pidfile = Cdef::CsAdmin.configuration.pidfile
            lock = Lockfile.new(Cdef::CsAdmin.configuration.lockfile, :retries => 0)
            lock.lock
            begin
              File.open(pidfile, 'w'){ |f| f.write("#{ Process.pid }") }
              new(options).run
            ensure
              if my_pid == $$
                lock.unlock rescue nil 
                File.delete(pidfile) rescue nil 
              end
            end
          end
        end

      end 

      attr_accessor :daemon, :port

      def initialize(options={})
        options.each do |key, val|
          meth = "#{ key }="
          send(meth, val) if respond_to?(meth)
        end
      end

      def config_ru
        @config_ru ||= File.expand_path(File.join(__FILE__, '..', '..', '..', '..', 'config.ru'))
      end

      def run
        c = config_ru  # needed
        app = Rack::Builder.new do
          eval("(" + File.read(c) + ")", nil, c)
        end.to_app
        if daemon
          dir = Dir.getwd
          Process.daemon
          Dir.chdir(dir)
        end
        Rack::Handler.get('mongrel').run(app, :Host => Cdef::CsAdmin.configuration.host, :Port => port || Cdef::CsAdmin.configuration.port)
      end

    end
  end
end
