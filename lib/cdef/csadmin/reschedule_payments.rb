

module Cdef
  module CsAdmin
    class ReschedulePayments <  Cdef::CsAdmin::Base

      get '/' do 
        @title = 'Reschedule Payments'

        # TODO: call Chris' service to get billing plan structure.
        #   From that compute real values to replace dummy ones below.
        @rebills = [[59.97, '2012-01-13'],
                    [59.97, '2013-01-13'],
                    [59.97, '2014-01-13'],
                   ]


        haml :ez_payment_schedule
      end

      post '/' do
        haml :ez_payment_success
      end
    end
  end
end
