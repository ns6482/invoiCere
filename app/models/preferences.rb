class Preferences < ActiveRecord::Base
  attr_accessible :date_format, :time_format, :number_format, :fiscal, :payment_stub, :discount, :shipping, :purchase_order_number, :email_alerts, :company_id
end
