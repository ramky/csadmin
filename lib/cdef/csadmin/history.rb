module Cdef
  module CsAdmin
    class History < Cdef::CsAdmin::Base
      p "loading  class History < Cdef::CsAdmin::Base"
      get '/' do 
        p 'getting view history'
        @title = 'View History'
        resource = rest_resource + "/" + "history/#{current_sale_id}/"

        @history = submit(current_user.username,
                         'GET', resource,               
                         current_user.api_key, params.to_json)

        #@history = [
        #  {'date' => '2010-1-1', 'name' => 'ram iyer', 'action' => 'Refund', 'status' => 'Success', 'details' => 'For $9.99'}
        #]
        haml :history
      end
    end
  end
end
