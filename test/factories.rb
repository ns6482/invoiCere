Factory.define :company do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :setting do |f|
   f.company {|company| company.association(:company) }
   f.vat 17.5
end

Factory.define :user do |f| 
  f.sequence(:email) { |n| "foo#{n}@foo.com" }
  f.password "password123"
  f.company {|company| company.association(:company) }
  f.roles { [Factory.create(:role, :name => 'admin')] }
  f.client_id ""
end

Factory.define :role do |f |
  f.name "admin"
end


Factory.define :client do |f|
  f.sequence(:company_name) { |n| "company#{n}" }
  f.address1 "40 Alderbrook Drive"
  f.address2 "test"
  f.zip "CV11 6PL"
  f.city "Nuneaton"
  f.country "United Kingdom"
  f.phone "02476 76735989"
  f.fax "33233 2323"
  f.email "nehal.soni@gmail.com"  
end

Factory.define :contact do |f|
  f.title "Mr"
  f.first_name "Nehal"
  f.last_name "Soni"
  f.job_title "Job Title"
  f.email "test@gmail.com"
  f.phone "2323232323"
  f.mobile "232323232323"
  f.fax "232323232"
  f.client {|client| client.association(:client) }
end

#Factory.define :delivery do |f|
#  f.message "message"
#  f.invoice {|invoice| invoice.association(:invoice) }
#end

#Factory.define :send do |s|
#  s.delivery {|d| d.association(:delivery)}
#  s.contact {|c| c.association(:contact)}
#end

#Factory.define :invoice do |f|  
#  f.invoice_date "2010-01-01 00:00:00"
#  f.title "title"
#  f.notes ""
#  f.tax_rate 17.5
#  f.delivery_charge 0
#  f.business_id "ID001"
#  f.purchase_order_id "PO2232"
#  f.state "draft"
#  f.late_fee "10.55"
#  f.due_days  7
#  f.total_cost_inc_tax_delivery 10
#  f.client {|client| client.association(:client) }  
#end

#Factory.define :invoice_item do |f|
#  f.item_type "type"
#  f.item_description "description"
#  f.qty 1
#  f.cost 10
#  f.invoice {|invoice| invoice.association(:invoice) }
#end

#Factory.define :reminder do |f|
#  f.default_message false
#  f.custom_message "MyText"
#  f.enabled false
#  f.days_before 1
#  f.last_send_status "MyString"
#  f.frequency "Weekly"
#  f.invoice_id 1
#end

#Factory.define :payment do |f|
#  f.invoice {|invoice| invoice.association(:invoice) }
#  f.user_id 1
#  f.amount 5
#  f.payment_type "cheque"
#  f.currency "sterling"
#end

#Factory.define :schedule do |f|
#  f.invoice {|invoice| invoice.association(:invoice) }
#  f.name 1
#  f.frequency 1
#  f.frequency_type "daily"
#  f.last_sent
#  f.next_send
#  f.due_on "2010-01-01 00:00:00"
#  f.end_date
#  f.enabled 1
#  f.send_to_client 1
#end

