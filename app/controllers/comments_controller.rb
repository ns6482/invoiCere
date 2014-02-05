class CommentsController < BaseController

  before_filter :find_invoice, :only => [:new, :index, :destroy]
  before_filter :find_comment, :only => :edit
  load_and_authorize_resource :invoice
  load_and_authorize_resource :comment, :through => :invoice, :shallow => true

  def index
     respond_to do |format|
      format.html
      format.js
    end
  end
   
  def new
    @comment = @invoice.comments.build
       
    respond_to do |format|
      format.html
      format.js {render :action => '../shared/modal/new'}
    end
  end
  
  def create

    if current_user
      @comment.user_id  = current_user.email
      #elsif current_account
      # @comment.user_id  = current_account.email
    end

    respond_to do |format|
      if @comment.save
        flash[:notice] = "Successfully created comment."
        format.html{redirect_to invoice_comments_path(@invoice)}
        format.js{render :action => '../shared/modal/create'}
      else
        format.html{render :action => 'new'}
        format.js {render :action => '../shared/modal/new'}
      end
    end
  end
          
  def destroy
    #@comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to invoice_comments_path(@invoice)
  end

  def find_comment
    c = Comment.find(params[:id])
    @comment = c if c.invoice.client.company_id == current_company
  end

  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
  end
end
