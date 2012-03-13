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
    end

  end

  def new
    @item = Item.new(:company_id=>current_company.id)
  end

  def create
    #@item = Item.new(params[:item])
    if @item.save
      redirect_to items_url, :notice => "Successfully created item."
    else
      render :action => 'new'
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

     i = 0
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
