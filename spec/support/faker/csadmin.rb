require 'rubygems'

module Faker
  module Cdef
    class CsAdmin
      class << self
        def account
          {
            :account_id => "ML_ACCOUNT_ID_00666",
            :email_address => "joe@theschmidts.com",
            :company => "Schmidt, Co.",
            :first_name => "Joe",
            :last_name => "Schmidt",
            :shipping_address => {
              :name => "Schmidt, Co. c/o Dr. Joe P. Schidt",
              :addr1 => "617 West 7th St.",
              :addr2 => "Floor 13",
              :addr3 => "Suite 1337",
              :city => "Los Angeles",
              :district => "CA",
              :postal_code => "90017",
              :country => "United States (US)",
              :phone => "333-555-5353"
            },
            :payment_method => {
              :credit_card => {
                :account => "5112010000000003",
                :expiration_date => "201208"
              },
              :account_holder_name => "Joe Schmidt",
              :billing_address => {
                :name => "Dr. Joe P. Schidt",
                :addr1 => "123 Pewter Parkway",
                :city => "Beverly Hills",
                :district => "CA",
                :postal_code => "90210",
                :country => "United States (US)",
                :phone => "333-555-5353"
              }
            }
          }
        end

        def sale
          {
            :skus => ["ML_SKU_00001", "ML_SKU_00002"],
            :billing_descriptor => "MaxMySpeedSuperCleanPC.com",
            :total => 199.99,
            :account => self.account,
            :currency => 'USD',
            :billing_mode_name => 'standard_v1',
          }
        end
      end
    end
  end
end
