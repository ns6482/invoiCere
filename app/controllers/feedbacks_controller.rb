class FeedbacksController < AccountController

  before_filter :find_invoice, :only => [:new, :index]
  before_filter :find_feedback, :only => [:edit, :show, :destroy]
  load_and_authorize_resource :invoice
  load_and_authorize_resource :feedback, :through => :invoice, :shallow => true

  def show    
  end

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    @feedback = @invoice.feedbacks.build
    @feedback.user_name = current_user.name
    @feedback.user_email = current_user.email
    @feedback.invoice_id = @invoice.id
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    respond_to do |format|
      @feedback.rating = params[:feedback][:rating]
      if @feedback.save
        flash[:notice] = "Successfully created feedback."        
        format.html{redirect_to @feedback}
        format.js
      else
        format.html{render :action => 'new'}
        format.js {render :action => 'new'}
      end
    end
  end
  
  def edit    
  end
  
  def update
    #@feedback = Feedback.find(params[:id])
    @feedback.rating = params[:feedback][:rating]
    if @feedback.update_attributes(params[:feedback])
      flash[:notice] = "Successfully updated feedback."
      redirect_to @feedback
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    #@feedback = Feedback.find(params[:id])
    @feedback.destroy
    flash[:notice] = "Successfully destroyed feedback."
    redirect_to invoice_url(@feedback.invoice)
  end

  def find_feedback
    f = Feedback.find(params[:id])
    @feedback = f if f.invoice.client.company_id == current_company
  end

  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
  end
end
