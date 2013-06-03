class ClientsController < BaseController

  before_filter :get_clients, :only => [:index]
  before_filter :find_client, :only => [:show, :edit, :destroy]
  load_and_authorize_resource
  # GET /clients
  # GET /clients.xml
  def index
    ##@clients = Client.all

    @search = @clients.search(params[:search])
    #@clients = @search.all
    @clients = @search.paginate :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
      format.js
      format.csv { send_data Client.to_csv(@clients)}
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    #@client = Client.find(params[:id])

    @invoices = @client.invoices.where(:type => 'standardInvoice')
    #TODO scheduled invoices
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    #@client = Client.new
    #@client.contacts.build

    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    #@client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    @client.company_id = current_company.id

    respond_to do |format|
      if @client.save
        flash[:notice] = 'Client was successfully created.'
        format.html { redirect_to :action => :index}
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    #@client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'Client was successfully updated.'
        format.html { redirect_to(@client) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    #@client = Client.find(params[:id])
    @client.destroy

    flash[:notice] = 'Client was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end

  def invite
    invite_client
    flash[:notice] = 'Invitation has been sent to client'
    redirect_to client_path(@client)
  end

  def delete_multiple

    respond_to do |format|

      i = 0
      #arr_item = Array.new
      @clients_to_delete = @clients.find(params[:client_ids])
      @clients_to_delete.each do |client|
      #invoice.destroy
      end

      flash[:notice] ='Clients successfully deleted.'
      format.html {redirect_to invoices_url}
      format.js { render :action => 'delete_multiple.js.erb'}
    end
  end

  private

  def get_clients
    #authorize! :read, current_company
    @clients_outstanding = current_company.clients.accessible_by(current_ability).with_aggregates.due.map {|client| client.id}
    @clients = current_company.clients.accessible_by(current_ability).with_aggregates#.accessible_by(current_ability, :read)
  end

  def find_client
    @client = current_company.clients.accessible_by(current_ability).find(params[:id])
  end

  def invite_client
    @user = User.invite!(:email => @client.email)
    @user.name = @client.name
    @user.email = @client.email
    @user.company_id = current_company.id
    @user.client_id = @client.id
    @user.roles << Role.find_by_name("Client")
    @user.save!
  end

end
