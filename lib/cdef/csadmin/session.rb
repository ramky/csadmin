
module Cdef
  module CsAdmin
    class Session < Cdef::CsAdmin::Base
      post '/sale_info' do
        puts "setting sale_info for user \##{session[:user]} at #{request.ip} to  '#{params[:sale_id]}'"

        session[:order] = JSON.parse(params.to_json)

        (session[:order]).to_json
      end
    end
  end
end
