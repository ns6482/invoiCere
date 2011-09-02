class InvoiceItemsController < AccountController
  def index
    @invoice_items = InvoiceItem.all
  end
  
  def show
    @invoice_item = InvoiceItem.find(params[:id])
  end
  
  def new
    @invoice_item = InvoiceItem.new
  end
  
  def create
    @invoice_item = InvoiceItem.new(params[:invoice_item])
    if @invoice_item.save
      flash[:notice] = "Successfully created invoice item."
      redirect_to @invoice_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @invoice_item = InvoiceItem.find(params[:id])
  end
  
  def update
    @invoice_item = InvoiceItem.find(params[:id])
    if @invoice_item.update_attributes(params[:invoice_item])
      flash[:notice] = "Successfully updated invoice item."
      redirect_to @invoice_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @invoice_item = InvoiceItem.find(params[:id])
    @invoice_item.destroy
    flash[:notice] = "Successfully destroyed invoice item."
    redirect_to invoice_items_url
  end
end
