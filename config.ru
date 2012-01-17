# NOTE: Explicitly add our lib path and override the currently installed gem.
lib = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(lib) unless $:.include?(lib)

require 'cdef/csadmin'
require 'cdef/logger'

use Cdef::Logger::RackErrors, Cdef.logger.with_scope(:scope => 'RackErrors')
use Cdef::Logger::RackAccess, Cdef.logger.with_scope(:scope => 'RackAccess')
use Cdef::Logger::RackLogger, Cdef.logger.with_scope(:scope => 'RackLogger')

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

map '/adjustment' do
  run ::Cdef::CsAdmin::Adjustment
end

map '/session' do
  run ::Cdef::CsAdmin::Session
end

map '/comment' do
  run ::Cdef::CsAdmin::Comment
end

map '/history' do
  run ::Cdef::CsAdmin::History
end

map '/auth' do
  run ::Cdef::CsAdmin::Auth
end

map '/accounts' do
  run ::Cdef::CsAdmin::Account
end

map '/account' do
  run ::Cdef::CsAdmin::Account
end

map '/license' do
  run ::Cdef::CsAdmin::License
end

map '/sale_details' do
  run ::Cdef::CsAdmin::SaleDetail
end

map '/retention' do
  run ::Cdef::CsAdmin::Retention
end

map '/bulk' do
  run ::Cdef::CsAdmin::Bulk
end

map '/reschedule_payments' do
  run ::Cdef::CsAdmin::ReschedulePayments
end
