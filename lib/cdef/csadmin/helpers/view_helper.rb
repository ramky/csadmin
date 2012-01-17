require 'sinatra/base'

module Sinatra
  module ViewHelper
    def h(text)
      Rack::Utils.escape_html(text)
    end

    def product_type_name(product_type_code)
      get_product_types_from_memcache[product_type_code]
    end
  end
  helpers ViewHelper
end
