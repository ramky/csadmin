# --*- ruby -*--

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

pkg_version = File.read(File.expand_path('../VERSION', __FILE__)).chomp

Gem::Specification.new do |s|
  s.name         = 'cdef-csadmin'
  s.version      = pkg_version
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Ram Iyer","Vahak Matavosian"]
  s.email        = ["ram@cyberdefender.com", "vahak@cyberdefender.com"]
  s.homepage     = "http://www.cyberdefender.com/"
  s.summary      = "CyberDefender Customer Service Admin V3"
  s.description  = "Internal tool for customer service reps to cancel, refund, upgrade, manage licenses, etc."
  s.require_path = 'lib'
  s.executables  = ['cdef-csadmin']
  s.add_dependency("parseexcel", ">= 0.5.2")
  s.add_dependency("mongrel", "~> 1.1.0")
  s.add_dependency("memcache-client", ">= 1.8.5")
  s.add_dependency("test-unit", ">= 2.1.1")
  s.add_dependency("rack-flash", ">= 0.1.1")
  s.add_dependency("haml", ">= 3.0.23")
  s.add_dependency("sinatra", ">= 1.1.0")
  s.add_dependency('vindicia4r', '>= 3.4.0')
  s.add_dependency('cdef-common', '>= 0.2.0')
  s.add_dependency('cdef-configuration', '>= 0.1.0')
  s.add_dependency("cdef-logger", ">= 0.2.2")
  s.add_dependency('cdef-models', '>= 0.3.12')
  s.add_development_dependency('rspec', '~> 1.3.0')
  s.add_development_dependency('rcov', '~> 0.9.0')
  s.add_development_dependency('faker', '~> 0.3.0')
  s.add_development_dependency('rack-test', '~> 0.5.0')
  s.add_development_dependency('shotgun', '~> 0.8.0')
  s.files = %w(README.rdoc Rakefile VERSION config.ru) +
    Dir.glob("{lib,public,views}/**/*") -
    Dir.glob("{lib,public,views}/**/*~")
end
