require 'subdomain'
require 'no_subdomain'  

VisioInvoiceV3::Application.routes.draw do   
    
 constraints(NoSubdomain) do    
  devise_for :users
  resource :company, :only => [:new, :create], :constraints => {:subdomain => ""}
  resource :home, :only => [:index]#, :constraints => {:subdomain => 'www'}
 end
 constraints(Subdomain) do
  #with_options :conditions => { :subdomain => /^[A-Za-z0-9-]+$/ } do |site|
    
    #site.resources :schedules, :only => [:index]

    #site.resources :invoices do |invoices|
      #invoices.resources :deliveries, :only => [:new, :create, :show, :index], :shallow =>true
      #invoices.resources :payments,:only => [:new, :create, :index, :destroy], :shallow =>true
      #invoices.resource :reminder, :only => [ :edit, :update, :show]
      #invoices.resources :comments, :only => [:new, :create, :destroy, :index], :shallow =>true
      #invoices.resources :invoice_items, :only => [:new, :create, :destroy, :index], :shallow =>true
      #invoices.resources :feedbacks, :only => [:new, :create, :destroy, :index], :shallow =>true
      #invoices.resource :schedule, :only => [:show, :new, :create, :destroy, :edit, :update]
    #end

    devise_for :users, :controllers => { :invitations => 'users/invitations' }
    #devise_for :users, :controllers => { :invitations => 'users/new_invite' }
    
    resources :users #do 
    #  collection do 
    #    get 'new_invite'
    #    post 'invite'
    #  end  
    #end
    
    resource :company, :only => [:edit, :update, :show]
    
    resources :clients do 
      member do
          put 'invite'
      end
      resources :contacts, :shallow =>true do  
        member do
          put 'invite'
          get 'new_invite'                            
        end
      end
    end
    
    resources :dashboard, :only => [:index]
    root :to => "dashboard#index"

  end
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
