# Load all libraries under cdef/rest/helpers/*
#
# Note that these libraries contain modules under the namespace Sinatra.
# This is in line with Sinatra extension development guidlines:
#
# http://www.sinatrarb.com/extensions.html
dir = __FILE__[%r{\A(?:(?:.*/)?lib/|\./)?(.*)\.rb\z}, 1]
Dir[File.join(__FILE__[%r{\A(.*)\.rb\z}, 1], '*.rb')].sort.each do |lib|
  require "#{ dir }/#{ File.basename(lib) }"
end
