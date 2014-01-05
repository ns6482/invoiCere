module DashboardsHelper
    
    def summary_x_axis(start_date)
       x = []
       (0..11).each  do | i |
         dt = start_date.to_date >> i
         x[i] = dt
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
end
