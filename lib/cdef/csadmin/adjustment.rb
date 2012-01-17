module Cdef
  module CsAdmin
    class Adjustment < Cdef::CsAdmin::Base
      get '/' do 
        @title = 'Adjustment'

        @details = Hash.new
        if current_sale_id
          resource = rest_resource + "/adjustment/" + current_sale_id
          response = submit(current_user.username, 
                  'GET', resource, 
                  current_user.api_key, params.to_json)

          if response.include?("exception")
            puts "Error"
            flash[:notice] = "Error"
          end 
          product_types = get_product_types_from_memcache

          @skus = response['skus']
        end
        haml :adjustment
      end

      post '/' do 

        upgrade_status = cancel_status = refund_status = "Failure"
        response = {}
        unless params['upgrade_skus'] == '' && params['cancel_skus'] == ''
          cancel_skus = params['cancel_skus'].split(",")
          params[:adjustment] = { :cancel_skus  => cancel_skus }

          unless params['upgrade_skus'] == ''
            skus_str = params['upgrade_skus'].split(",").join("&number[]=")
            resource = rest_resource + "/skus?currency=USD&number[]=#{skus_str}"
            response = submit(current_user.username, 
                          'GET', resource, 
                          current_user.api_key, params.to_json)
            if response.include?("exception")
              @status = response['exception']['message']
              return haml(:message)
            end
            params[:adjustment][:sale][:sale_lines] = { :upgrade_skus  => response }
          end

          resource = rest_resource + "/sales/#{current_order_id}"
          response = submit(current_user.username, 
                          'PUT', resource, 
                          current_user.api_key, params.to_json)
        end
        if !response.include?('exception')
          upgrade_status = 'Success' unless params['upgrade_skus'] == ''
          cancel_status = 'Success' unless params['cancel_skus'] == ''
          if params["refund"] 
            action_url = "/refund/#{current_sale_id}/#{params[:refund_amount]}"
            resource = rest_resource + action_url
            response = submit(current_user.username, 
                          'POST', resource, 
                          current_user.api_key, params.to_json)
          end
        end

        @title = 'Adjustment'
        # Need friendly name hence not using action_name
        @action = 'adjustment'
        if response.include?("exception")
          @status = response['exception']['message']
        else
          refund_status = 'Success' unless params['refund_skus'] == ''
          @status = "Adjustment operations were successful."
        end

        history = []
        ['upgrade_skus', 'cancel_skus', 'refund'].each {|s|
          desc = "Refunded"
          type = 'Refund'
          status = refund_status

          if s == 'upgrade_skus'
            desc = "Upgraded to #{params[s]}"
            type = 'Upgrade'
            status = upgrade_status
          elsif s == 'cancel_skus'
            desc = "#{params[s]} were cancelled"
            type = 'Cancel'
            status = cancel_status
          end

          unless params[s] == ''
            history << {
              :description => desc,
              :action_type => type,
              :action_status => status,
              :amount => s == 'refund' ? params['refund_amount'] : 0.00
            }
          end
        }

        params[:history] = {
          :sale_id => current_sale_id,
          :user_id => current_user.id,
          :operations => history
        } 

        resource = rest_resource + "/history"
        response = submit(current_user.username, 
                          'POST', resource, 
                          current_user.api_key, params.to_json)

        if response.include?("exception")
          @status += response['exception']['message']
        end

        haml :message
      end
    end
  end
end
