

module Cdef
  module CsAdmin
    class SaleDetail < Cdef::CsAdmin::Base
      @title = 'Sale Details'
      get '/' do 
        @details = nil
        unless current_sale_id.nil?
          resource = rest_resource + "/sales/#{current_sale_id}/details"
          response = submit(current_user.username, 
                'GET', resource, 
                current_user.api_key, params.to_json)

          if response.include?("exception")
            puts "Error"
            flash[:notice] = "Error"
          end
          product_types = get_product_types_from_memcache

          @details = response['sale']
        end

        haml :'sale_details/show'
      end
    end
  end
end
