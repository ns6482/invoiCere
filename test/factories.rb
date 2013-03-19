FactoryGirl.define do 
 factory  :company do 
  sequence(:name) { |n| "foo#{n}" }
  end

  factory :setting do 
   company {|company| company.association(:company) }
   vat 17.5
  end

  factory :user do  
    sequence(:email) { |n| "foo#{n}@foo.com" }
    password "password123"
    company {|company| company.association(:company) }
    roles { [FactoryGirl.create(:role, :name => 'viewer')] }
    client_id ""
  end

  factory :role do 
   name "admin"
  end


  factory :client do 
   sequence(:company_name) { |n| "company#{n}" }
   address1 "40 Alderbrook Drive"
   address2 "test"
   zip "CV11 6PL"
   city "Nuneaton"
   country "United Kingdom"
   phone "02476 76735989"
   fax "33233 2323"
   email "nehal.soni@gmail.com"  
   #company {|company| company.association(:company) }
  end

  factory :contact do 
   title "Mr"
   first_name "Nehal"
   last_name "Soni"
   job_title "Job Title"
   email "test@gmail.com"
   phone "2323232323"
   mobile "232323232323"
   fax "232323232"
   #client {|client| client.association(:client) }
  end  

  factory :delivery do 
    message "message"
    invoice {|invoice| invoice.association(:invoice) }
  end

  factory :send do
    delivery {|d| d.association(:delivery)}
    contact {|c| c.association(:contact)}
  end

  factory :invoice do   
    invoice_date "2010-01-01 00:00:00"
    title "title"
    notes ""
    tax_rate 17.5
    #delivery_charge 0
    business_id "ID001"
    purchase_order_id "PO2232"
    state "draft"
    late_fee "10.55"
    due_days  7
    #total_cost_inc_tax_delivery 10
    client {|client| client.association(:client) }  
  end

  factory :invoice_item do 
   #item_type "type"
   #item_description "description"
   #qty 1
   #cost 10
   #invoice {|invoice| invoice.association(:invoice) }
  end

  factory :reminder do 
   default_message false
   custom_message "MyText"
   enabled false
   days_before 1
   last_send_status "MyString"
   frequency "Weekly"
   invoice_id 1
  end

  factory :payment do 
   invoice {|invoice| invoice.association(:invoice) }
   user_id 1
   amount 5
   payment_type "cheque"
   currency "sterling"
   status "paid"
  end

  factory :schedule do 
   invoice {|invoice| invoice.association(:invoice) }
   name 1
   frequency 1
   frequency_type "daily"
   last_sent
   next_send
   due_on "2010-01-01 00:00:00"
   end_date
   enabled 1
   send_to_client 1
  end

end
