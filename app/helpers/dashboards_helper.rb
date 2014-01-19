module DashboardsHelper
    
    def summary_x_axis(start_date)
       x = []
       (0..11).each  do | i |
         dt = start_date.to_date >> i
         x[i] = dt.strftime('%b %y')
       end
       x.to_a.to_json
    end
    
    def summary_y_axis(summaries, start_date, graph_type)
       months = Hash.new { |h,k| h[k] = {} }
       y = []
       (0..11).each  do | i |
         dt = start_date.to_date >> i
         ['EUR', 'GBP'].each do |c|
          months[c.to_sym][dt] = 0
          end
        end
       
       summaries.to_a.each do | total |
         months[total.currency.to_sym][Date.new(total.yr, total.mo)] =  (graph_type == 'invoice' ? total.total_amount_closed : total.total_payments)
       end
       
       months.keys.each do  | currency |
          y.push({:name => currency, :data => months[currency.to_sym].values})
       end
       
       y.to_json
    end
    
    def summary_y_axis2(summs, start_date, graph_type)
       
       
       currencies = ['EUR', 'GBP']
       
       months = Hash.new { |h,k| h[k] = {} }
       (0..11).each  do | i |
         dt = start_date.to_date >> i
         currencies.each do |c|
          months[dt][c.to_sym] = 0
          end
        end
         
       summs.to_a.each do | total |         
         dt = Date.new(total.yr, total.mo)
         if months.has_key?(dt)
          months[dt][total.currency.to_sym] =  (graph_type == 'invoices' ? total.total_amount_closed : total.total_payments)
         end 
       end

       data = []
       data.push(['Date'] | currencies)
       
       months.keys.each do | month|
         data.push([month.strftime('%b %y')] + months[month].values)
       end
       
       data
       
            
    end
    
     def summary_y_axis3(sums, start_date, graph_type)
       
      
       clients= sums.to_a.map { | c | c.company_name}
       
       sums = sums.group_by {| s | s.currency}
       
       summaries = Hash.new { |h,k| h[k] = {} }
         
       sums.to_a.each do | currency, totals |
         totals.each do | s|         
          summaries[s.company_name.to_sym][currency.to_sym] =  (graph_type == 'invoices' ? s.total_amount_closed : s.total_payments) + 0
         end
       end

       data = []
       data.push(['Client'] | sums.keys)
       
       summaries.keys.each do | client|
         data.push([client.to_s] + summaries[client].values)
       end
       
       data
       
            
    end
    
    
  
    
    
    
end
