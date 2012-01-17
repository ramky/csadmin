

module Cdef
  module CsAdmin
    class Retention < Cdef::CsAdmin::Base

      get '/' do 
        @title = 'Retention'
        
        resource = rest_resource + "/sales/#{current_order_id}/skus"
        owned_skus  = submit(current_user.username, 
                             'GET', resource, 
                             current_user.api_key, params.to_json)
        owned_sku_numbers = owned_skus.map{|s| s["number"] }

        # TODO: check for exception after cdef-rest call, e.g.
        # {"exception"=>
        #  {"class"=>"Cdef::Rest::UnknownResourceError", "message"=>"Unknown Resource"}}

        resource = rest_resource + "/skus?scope=retention"

        @retention_skus = submit(current_user.username, 
                                'GET', resource, 
                                 current_user.api_key, params.to_json)
        
        # TODO: check for exception after cdef-rest call


        # does the user already own this sku?
        # TODO: cannot check for already owned skus like this anymore!
        @retention_skus.each do |retention_sku|
           if owned_skus.member?(retention_sku["number"])
             retention_sku['already_owned'] = true
           end
        end

        haml :retention
      end

      post '/' do
        #  Expect params hash to look like this:
        #  {"ML_SKU_00003"=>"on"}
        #  TODO: validate params.  
        retention_skus = params.inject([]) do |memo, pair|
          if "on" == pair.last
            memo << pair.first
          else
            memo
          end
        end


        # defensive coding - should check to be sure array is not empty:
        query = retention_skus.split(",").join("&number[]=")
        resource = rest_resource + "/skus?currency=USD&number[]=#{query}"
        response = submit(current_user.username, 
                      'GET', resource, 
                      current_user.api_key, {}.to_json)

        if response.include?("exception")
          @status = response['exception']['message']
          return haml(:message)
        else
          sales_payload = {:sale =>
            {
              :country            => 'US',
              :currency           => 'USD',
              :sale_lines         => response,
              :customer           => {:customer_id     => current_order['customer_id']}
            }
          }

          puts "RETENTION SKUS"
          pp response

          
          
          # perform retention sale
          resource = rest_resource + "/sales"
          @retention_skus = submit(current_user.username, 
                                   'POST', resource, 
                                   current_user.api_key,
                                   sales_payload.to_json)
          

          # TODO: test to see if there was an exception
          # if not, then log it to history
          ops = @retention_skus.map do |rsku|
            {
              :description => "Retention added",
              :action_type => "Retention",
              :action_status => "Success",
              :amount => 0.0
            }
          end

          history_payload = {:history => {
              :sale_id => current_sale_id,
              :user_id => current_user.id,
              :operations => ops
            }
          } 
          
          resource = rest_resource + "/history"
          response = submit(current_user.username, 
                            'POST', resource, 
                            current_user.api_key, history_payload.to_json)
          
          if response.include?("exception")
            @status += response['exception']['message']
          end
          
          @title = 'Posted Retention'
          haml :retention_success
        end
      end
    end
  end
end
