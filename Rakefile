# --*- ruby -*--

require 'rubygems'
require 'rake'

pkg_name = 'cdef-csadmin'
pkg_version = File.read(File.expand_path('../VERSION', __FILE__)).chomp

desc 'Build a gem package and create directory for lock and pid files for Mongrel'
task :package do
  require 'fileutils'
  require File.join(File.dirname(__FILE__), 'lib/cdef/csadmin/configuration')
  conf = Cdef::CsAdmin::Configuration.new
  FileUtils.mkdir_p(conf.lockfile_dir)
  FileUtils.chmod(0777, conf.lockfile_dir)
  FileUtils.mkdir_p(conf.pidfile_dir)
  FileUtils.chmod(0777, conf.pidfile_dir)
  system "gem build #{ pkg_name }.gemspec"
  Dir.mkdir('pkg') rescue nil 
  system "mv -f #{ pkg_name }-#{ pkg_version }.gem pkg/"
end

desc 'Build a gem package'
task :build => [:package] do
  # same as :package
end

require 'rake/clean'
CLEAN.include ['**/*~', 'pkg', 'coverage', 'rdoc', 'tmp', "#{ pkg_name }*.gem"]

desc 'Install the package as a gem'
task :install => [:clean, :package] do
  sh "gem install --local pkg/#{ pkg_name }-#{ pkg_version }.gem"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{ pkg_name } v#{ pkg_version }"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options = ["--charset", "utf-8", "--line-numbers"]
end

task :default => :rcov

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
