class InvoiceReport < Prawn::Document
  
  attr_accessor :invoice, :current_company, :content

    
def add_page_break_if_overflow (&block)
  current_page = page_count
  roll = transaction do
    yield
  
    rollback if page_count > current_page
  end
  
  if roll == false
    start_new_page
    yield
  end
end




#pdf = Prawn::Document.new(:page_layout => :portrait, :page_size => "A4", :margin => [25,25,25,25])


def initialize(invoice)
  @invoice = invoice
  @current_company = @invoice.client.company
  @content = ""
  super(:page_layout => :portrait, :page_size => "A4", :margin => [25,25,25,25])
end

def to_pdf
   
  company_contact = ""
  
  if !@current_company.setting.telephone.nil?
    if @current_company.setting.telephone.length > 0
      company_contact += "Tel: #{@current_company.setting.telephone}   "
    end
  end

  if !@current_company.setting.fax.nil?
    if @current_company.setting.fax.length >0 
      company_contact += "Fax: #{@current_company.setting.fax}   "
     end
  end

  if !@current_company.setting.email.nil?
    if @current_company.setting.email.length >0
      company_contact += "Email: #{@current_company.setting.email}"
    end
  end
  
  
  
  ################################################################################
  # PDF HEADER
  ################################################################################
  
  time = Time.new

  repeat :all do
    text "Printed on " + @current_company.preference.convert_datetime(time), :align=> :right, :size => 8
  end

 


  ################################################################################
  # PDF FOOTER (without page number which must be the last line of code)
  ################################################################################
  
  repeat :all do
    bounding_box [margin_box.left, margin_box.bottom + 20], :width => margin_box.width, :height => margin_box.height - 60 do 
        stroke_horizontal_rule
        move_down 10
        str = ''
        
        if !@current_company.setting.company_registration.nil?
            str = "Company Registration No: #{@current_company.setting.company_registration}"
        end

        if !@current_company.setting.vat_registration.nil?
            str = "VAT Registration No: #{@current_company.setting.vat_registration}"
        end

        text "Generated with VisioInvoice (C). 2011. All Rights Reserved", :align => :center, :size => 9
        text str, :align => :center, :size => 9
    end
  end


  #SET THE BOUNDING BOX SO CONTENT DOESN'T OVERLAP THE HEADER AND FOOTER
  bounding_box([margin_box.left, margin_box.top - 10], :width => margin_box.width, :height => margin_box.height - 120) do
   
    if @current_company.setting.logo?
      image open("http://#{request.host_with_port}#{@current_company.setting.logo.url}"), :fit => [80, 80], :align => :left, :valign => :top
    end

   text "#{@current_company.setting.company_name}", :size => 14, :align => :center,  :style => :bold
   text "#{@current_company.setting.address}", :size => 8, :align => :center
   text company_contact, :size => 8, :align => :center  

   text "#{@invoice.client.address1}", :size => 8, :align => :left
   text "#{@invoice.client.address2}", :size => 8, :align => :left
   text "#{@invoice.client.zip}", :size => 8, :align => :left
   text "#{@invoice.client.city}", :size => 8, :align => :left
   text "#{@invoice.client.country}", :size => 8, :align => :left
   text "Phone: #{@invoice.client.phone}", :size => 8, :align => :left
   text "Fax: #{@invoice.client.fax}", :size => 8, :align => :left
   text "Email: #{@invoice.client.email}", :size => 8, :align => :left
    
   move_down 10
   text "Invoice", :size => 24, :style => :bold, :align => :left

   move_down 10

   items =
   [
   ["Invoice ID","Your ID", "Purchase Order ID", "Invoice Date", "Due Date", "Currency"],
   [@invoice.id,@invoice.business_id,@invoice.purchase_order_id,@current_company.preference.convert_date(@invoice.invoice_date), current_company.preference.convert_date(@invoice.due_date), current_company.preference.currency_format]
   ]

   header_table = make_table(items, :header => true) do
       cells.size = 9
       cells.padding = 2
       row(0).style(:font_style => :bold, :background_color => 'C3D9FF')
   end

   bounding_box [bounds.left, cursor], :width => 150 do
       header_table.draw
   end
   
   move_down 20
   text "#{@invoice.title}", :size => 14
   move_down 20

   invoice_items =  [["Type","Description","Cost","Qty"]]
   
   invoice_items += @invoice.invoice_items.map do |item|
        [
            item.item_type,
            item.item_description,
            #number_to_currency(item.cost, :unit => "£", :separator => ".", :delimiter => ","),
            item.cost,
          item.qty
       ]
   end

    main_table = make_table(invoice_items, :header => true,:width => 400) do
        cells.size = 9
        cells.padding = 2
        row(0).style(:font_style => :bold, :background_color => 'C3D9FF')
    end

    main_table.draw
    move_down 15

    summary_items =
    [
        ["Tax Rate",@invoice.tax_rate],
        ["Item Subtotal",@invoice.total_cost],
        ["Item Subtotal inc Tax", @invoice.total_cost_inc_tax],
        ["Delivery Charge", @invoice.delivery_charge],
        ["Total",@invoice.total_cost_inc_tax_delivery],
    ]


    summary_table = make_table(summary_items, :header => true, :width => 150) do
        cells.size = 9
        cells.padding = 2
        column(0).style(:font_style => :bold)
    end


    bounding_box [margin_box.width-(margin_box.width-250), cursor], :width => 150 do
      summary_table.draw
    end

    move_down 10

   bounding_box [bounds.left, cursor], :width => margin_box.width do
         move_down 5
        indent(5) do
            text "#{@invoice.notes}"
            text "Payment Due #{@invoice.remaining_amount}", :align => :center, :style => :bold
            move_down 1
            if @invoice.late_fee
               text "This invoice is due in #{@invoice.due_days} day(s), the late fee is set to #{@invoice.late_fee}", :align => :center
            end
           move_down 1

            stroke do
                line bounds.top_left,    bounds.bottom_left
                line bounds.top_left,    bounds.top_right
                line bounds.bottom_left, bounds.bottom_right
                line bounds.top_right,    bounds.bottom_right
            end
        end
    end

    move_down 25


    dash(1, :space=> 2, :phase => 0)
    bounding_box [bounds.left, cursor], :width => margin_box.width do
      stroke do          
        line bounds.top_left, bounds.top_right       
      end
      #move_down 5
     end
     
     undash
        
   
    if @current_company.preference.payment_stub =1
      
     
   
      add_page_break_if_overflow do |pdf|
        move_down 5
        text "Payment Stub", :align => :left, :size => 11, :style => :bold
        text content, :align => :left, :size => 11, :style => :bold, :color => :white
        move_down 10

        summary_items =
        [
            ["Client Details",@invoice.client.name],
            ["Invoice Date",@invoice.invoice_date],
            ["Total due", @invoice.remaining_amount],
            ["Invoice ID", @invoice.id]
        ]


        summary_table = make_table(summary_items, :header => true, :width => 150) do
            cells.size = 8
            cells.padding = 2
            column(0).style(:font_style => :bold)
        end
    
        summary_table.cells.style { |cell| cell.border_width = 0 }
        summary_table.draw
       
        stroke do
            line bounds.top_left, bounds.top_right
        end

        move_down 10
      
        stroke_rectangle([90, cursor], 100, 15)
        
        indent(3) do
            text "Amount Closed: ", :size => 8, :style => :bold, :align => :left
        end

        move_down 10
        
        stroke_rectangle([90, cursor], 100, 15)

        indent(3) do
            text "Date: ", :size => 8, :style => :bold
        end
       move_down 10

       if !@current_company.setting.payment_instructions_1.nil?
           text @current_company.setting.payment_instructions_1, :size => 8, :align => :left
       end
        
       text "#{@current_company.name}", :size => 8, :align => :center,  :style => :bold
       text "#{@current_company.setting.address}", :size => 8, :align => :center
       text company_contact, :size => 8, :align => :center
    end
    
    
  end
end


  

  #number_pages "Page <page> of <total>", :at => [margin_box.right-65, -10], :page_filter => :all, :size => 8

  render
end
    
end
