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
      format.csv {

        items = CSV.generate do |csv|
          
          
          
          csv << ["Name", "Address 1", "Address 2", "Zip", "City", "Country", "Phone", "Fax", "Email", "Created", "Contact Title", "Contact First Name", "Contact Last Name", "Contact Job Title", "Contact Email", "Contact Phone", "Contact Mobile", "Contact Fax", "Contact Created" ]
          @clients.each do |cl|
            val = [cl.company_name, cl.address1, cl.address2, cl.zip, cl.city, cl.country, cl.phone, cl.fax, cl.email, cl.created_at] 
            
            if cl.contacts.first
              val += [cl.contacts.first.title, cl.contacts.first.first_name, cl.contacts.first.last_name, cl.contacts.first.job_title, cl.contacts.first.email, cl.contacts.first.phone, cl.contacts.first.mobile, cl.contacts.first.fax, cl.contacts.first.created_at]            
            end
            
            csv << val
            
            counter = 0

            if cl.contacts.count > 1
              cl.contacts.each do |contact|
                if counter != 0 then
                  csv << ["", "", "", "", "", "", "", "", "", "", contact.first.title, contact.first_name, contact.last_name, contact.job_title, contact.email, contact.phone, contact.mobile, contact.fax, contact.created_at]
                end
                counter +=1
              end
            end

          end
        end

        send_data items

      }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    #@client = Client.find(params[:id])

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
    @clients_outstanding = current_company.clients.with_aggregates.due.map {|client| client.id}
    @clients = current_company.clients.with_aggregates#.accessible_by(current_ability, :read)
  end

  def find_client
    @client = current_company.clients.find(params[:id])
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
