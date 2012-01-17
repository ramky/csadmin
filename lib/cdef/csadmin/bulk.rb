
module Cdef
  module CsAdmin
    class Bulk < Cdef::CsAdmin::Base
      helpers Sinatra::BulkOperationHelper
      get '/' do 
        @title = 'Bulk Refund/Cancellations'
        @orders = []
        haml :bulk
      end

      post '/refund' do 
        begin
          records = process_file(params)
        rescue Exception => e
          flash[:notice] = "Error Processing Bulk Refunds: #{e}"
        end

        pp records
        haml :bulk
      end

      post '/cancel' do 
        begin
          records = process_file(params)
        rescue Exception => e
          flash[:notice] = "Error Processing Bulk Cancellations: #{e}"
        end

        pp records
        haml :bulk
      end
    end
  end
end
