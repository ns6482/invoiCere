
pdf = Prawn::Document.new(:page_layout => :portrait, :page_size => "A4", :margin => [50,50,50,50])

content = <<-EOS

EOS


company_contact = ""

if current_company.setting.telephone.length >0
  company_contact += "Tel: #{current_company.setting.telephone}   "
end

if current_company.setting.fax.length >0
  company_contact += "Fax: #{current_company.setting.fax}   "
end

if current_company.setting.email.length >0
  company_contact += "Email: #{current_company.setting.email}"
end


################################################################################
# PDF HEADER
################################################################################
time = Time.new
pdf.repeat :all do
  pdf.text "Printed on " + time.strftime("%B %d, %Y"), :align=> :right, :size => 8
end

################################################################################
# PDF FOOTER (without page number which must be the last line of code)
################################################################################
pdf.repeat :all do
    pdf.bounding_box ([pdf.margin_box.left, pdf.margin_box.bottom + 20], :width => pdf.margin_box.width, :height => pdf.margin_box.height - 60) do
        pdf.stroke_horizontal_rule
        pdf.move_down 10
        str = ''
        if !current_company.setting.company_registration.nil?
            str = "Company Registration No: #{current_company.setting.company_registration}"
        end

        if !current_company.setting.vat_registration.nil?
            str = "VAT Registration No: #{current_company.setting.vat_registration}"
        end

        pdf.text "Generated with VisioInvoice. © 2011. All Rights Reserved", :align => :center, :size => 9
        pdf.text str, :align => :center, :size => 9
  end
end

# SET THE BOUNDING BOX SO CONTENT DOESN'T OVERLAP THE HEADER AND FOOTER
pdf.bounding_box([pdf.margin_box.left, pdf.margin_box.top - 10], :width => pdf.margin_box.width, :height => pdf.margin_box.height - 120) do
   
   if current_company.setting.logo?
     pdf.image open("http://#{request.host_with_port}#{current_company.setting.logo.url}"), :fit => [80, 80], :align => :left, :valign => :top
   end

   pdf.text "#{current_company.setting.company_name}", :size => 14, :align => :center,  :style => :bold
   pdf.text "#{current_company.setting.address}", :size => 8, :align => :center
   pdf.text company_contact, :size => 8, :align => :center  
    #pdf.image open("http://#{request.host_with_port}#{current_company.setting.logo.url}"), :position => :center, :width => 30
    #pdf.move_down 5
    #pdf.text "#{current_company.name}", :size => 14, :align => :center

    #pdf.text "#{@invoice.client.name}", :size => 8, :align => :center,  :style => :bold
    #pdf.text "#{current_company.setting.address}", :size => 8, :align => :center
    #pdf.text company_contact, :size => 8, :align => :center  

    #pdf.move_down 10

  #  pdf.bounding_box [338,pdf.cursor+40], :width => 200 do
        pdf.text "#{@invoice.client.address1}", :size => 8, :align => :left
        pdf.text "#{@invoice.client.address2}", :size => 8, :align => :left
        pdf.text "#{@invoice.client.zip}", :size => 8, :align => :left
        pdf.text "#{@invoice.client.city}", :size => 8, :align => :left
        pdf.text "#{@invoice.client.country}", :size => 8, :align => :left
        pdf.text "Phone: #{@invoice.client.phone}", :size => 8, :align => :left
        pdf.text "Fax: #{@invoice.client.fax}", :size => 8, :align => :left
        pdf.text "Email: #{@invoice.client.email}", :size => 8, :align => :left
    #end

   pdf.move_down 10
   pdf.text "Invoice", :size => 24, :style => :bold, :align => :left

    pdf.move_down 10

    items =
    [
    ["Invoice ID","Your ID", "Purchase Order ID", "Invoice Date", "Due Date"],
    [@invoice.id,@invoice.business_id,@invoice.purchase_order_id,@invoice.invoice_date, @invoice.due_date]
    ]

    header_table = pdf.make_table(items, :header => true) do
        cells.size = 9
        cells.padding = 2
        row(0).style(:font_style => :bold, :background_color => 'C3D9FF')
    end

    pdf.bounding_box [pdf.bounds.left, pdf.cursor], :width => 150 do
        header_table.draw
    end


    pdf.move_down 20
    pdf.text "#{@invoice.title}", :size => 14
    pdf.move_down 20

    invoice_items =  [["Type","Description","Cost","Qty"]]
    invoice_items += @invoice.invoice_items.map do |item|
        [
            item.item_type,
            item.item_description,
            number_to_currency(item.cost, :unit => '£', :separator => ".", :delimiter => ","),
        item.qty
       ]
    end

    invoice_items += invoice_items  
    invoice_items += invoice_items

    main_table = pdf.make_table(invoice_items, :header => true,:width => 400) do
        cells.size = 9
        cells.padding = 2
        row(0).style(:font_style => :bold, :background_color => 'C3D9FF')
    end

    main_table.draw
    pdf.move_down 15

    summary_items =
    [
        ["Tax Rate",number_to_percentage(@invoice.tax_rate, :precision => 2)],
        ["Item Subtotal",number_to_currency(@invoice.total_cost, :unit => '£', :separator => ".", :delimiter => ",")],
        ["Item Subtotal inc Tax", number_to_currency(@invoice.total_cost_inc_tax, :unit => '£', :separator => ".", :delimiter => ",")],
        ["Delivery Charge",number_to_currency(@invoice.delivery_charge, :unit => '£', :separator => ".", :delimiter => ",")],
        ["Total",number_to_currency(@invoice.total_cost_inc_tax_delivery, :unit => '£', :separator => ".", :delimiter => ",")],
    ]


    summary_table = pdf.make_table(summary_items, :header => true, :width => 150) do
        cells.size = 9
        cells.padding = 2
        column(0).style(:font_style => :bold)
    end


    pdf.bounding_box [pdf.margin_box.width-(pdf.margin_box.width-250), pdf.cursor], :width => 150 do
      summary_table.draw
      #pdf.dash(20, :space=> 2, :phase => 1)
    end

    pdf.move_down 10

   pdf.bounding_box [pdf.bounds.left, pdf.cursor], :width => pdf.margin_box.width do
        pdf.move_down 5
        pdf.indent(5) do
            pdf.text "#{@invoice.notes}"
            pdf.text "Payment Due #{number_to_currency(@invoice.remaining_amount, :unit => '£', :separator => ".", :delimiter => ",")}", :align => :center, :style => :bold
            pdf.move_down 1
            if @invoice.late_fee
                pdf.text "This invoice is due in #{pluralize(@invoice.due_days, 'day')}, the late fee is set to #{number_to_currency @invoice.late_fee, :unit => '£', :separator => ".", :delimiter => ","}", :align => :center
            end
           pdf.move_down 1

            pdf.stroke do
                pdf.line pdf.bounds.top_left,    pdf.bounds.bottom_left
                pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
                pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
                pdf.line pdf.bounds.top_right,    pdf.bounds.bottom_right
            end
        end
    end


  pdf.move_down 30

         pdf.dash(5, :space=> 5, :phase => 0)
     

       pdf.text content, :align => :left, :size => 14, :style => :bold, :color => :white
       pdf.text "Payment Stub", :align => :left, :size => 14, :style => :bold
      pdf.move_down 10

       summary_items =
       [
            ["Client Details",@invoice.client.name],
            ["Invoice Date",@invoice.invoice_date],
            ["Total due", number_to_currency(@invoice.remaining_amount, :unit => '£', :separator => ".", :delimiter => ",")],
            ["Invoice ID", @invoice.id]
        ]


        summary_table = pdf.make_table(summary_items, :header => true, :width => 150) do
            cells.size = 9
            cells.padding = 2
            column(0).style(:font_style => :bold)
        end
    
       # pdf.bounding_box [pdf.bounds.left, pdf.cursor], :width => 150 do
            summary_table.cells.style { |cell| cell.border_width = 0 }
            summary_table.draw
        #end
        
        pdf.stroke do
            pdf.line pdf.bounds.top_left, pdf.bounds.top_right
        end

        pdf.move_down 15
        pdf.undash

        
        pdf.stroke_rectangle([90, pdf.cursor], 100, 15)
        
        pdf.indent(3) do
            pdf.text "Amount Closed: ", :size =>10,  :style => :bold, :align => :left
        end

        pdf.move_down 15
        
        pdf.stroke_rectangle([90, pdf.cursor], 100, 15)

        pdf.indent(3) do
            pdf.text "Date: ", :size => 10, :style => :bold
        end
       pdf.move_down 15

       if !current_company.setting.payment_instructions_1.nil?
           pdf.text current_company.setting.payment_instructions_1, :size => 8, :align => :left
       end

        
       pdf.text "#{@invoice.client.name}", :size => 8, :align => :center,  :style => :bold
       pdf.text "#{current_company.setting.address}", :size => 8, :align => :center
       pdf.text company_contact, :size => 8, :align => :center


 
end

# PAGE NUMBERS
pdf.number_pages "Page <page> of <total>", :at => [pdf.margin_box.right-65, 0], :page_filter => :all, :size => 8

