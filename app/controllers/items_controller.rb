class ItemsController < BaseController
  
  load_and_authorize_resource


  def index
    @items = current_company.items.all
    
    respond_to do | format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
      format.json { 
        @items.map! {|item| {:value => item.name, :item_description => item.description, :item_type => item.unit,  :cost => item.price}} # 
        render :json => @items 
       }
       format.csv {
         send_data Item.to_csv(@items)         
         }
    end

  end

  def new
    
    @item = Item.new
    @item.company_id = current_company.id
    
    respond_to do | format |
      format.js {render :action => '../shared/modal/new'}
      format.html
    end
   
  end

  def create

   respond_to do | format |
     
    if @item.save
     @items = current_company.items.all

     format.js #{render :action => '../shared/modal/create'}
     
     format.html {render :action => 'index'}
    else
      format.html {render :action => 'new'}
      format.js {render :action => '../shared/modal/new'}      
    end
   end
    
  end

  def edit
    #@item = Item.find(params[:id])
  end

  def update
    #@item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to @item, :notice  => "Successfully updated item."
    else
      render :action => 'edit'
    end
  end

  def destroy
    #@item = Item.find(params[:id])
    @item.destroy
    redirect_to items_url, :notice => "Successfully destroyed item."
  end
  
  def delete_multiple

   respond_to do |format|


     #arr_item = Array.new
     @items_to_delete = @items.find(params[:item_ids])
     @items_to_delete.each do |item|
       item.destroy 
     end
     
     flash[:notice] ='Items successfully deleted.'
     format.html {redirect_to items_url}  
     format.js { render :action => 'delete_multiple.js.erb'}
   end
  end
end
