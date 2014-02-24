require 'subdomain'
require 'no_subdomain'  

VisioInvoiceV3::Application.routes.draw do   
    
 get "gocardless/index"

 constraints(NoSubdomain) do    
  devise_for :users
  resource :company, :only => [:new, :create], :constraints => {:subdomain => ""}
  resource :home, :only => [:index]#, :constraints => {:subdomain => 'www'}
  
  get "gocardless/index"
  post "gocardless/submit"
  get "gocardless/confirm"
  get "gocardless/cb"
  get "gocardless/setup_merchant"
  post "gocardless/webhook"
  


 end
 
 constraints(Subdomain) do
   
   get "preview/show" 
   get "gocardless/index"
   post "gocardless/submit"
   get "gocardless/confirm"
   get "gocardless/setup_merchant"
   get "gocardless/cb"
   get "gocardless/new"
   post "gocardless/webhook"
   get "payments/confirm"
   post "payments/complete"


  #with_options :conditions => { :subdomain => /^[A-Za-z0-9-]+$/ } do |site|
    
 
  
    resources :schedules do
      collection do
        delete :delete_multiple
      end
      #resource :client, :only => [:new]
    end#, :only => [:index, :new]
    
    
    resources :items do#, :only => [:new, :create, :index, :destroy]
      collection do
        delete :delete_multiple
      end
    end

    resources :invoices do
      collection do
        delete :delete_multiple
      end
      
      resources :deliveries, :shallow =>true do 
        collection do
          delete :delete_multiple
        end  
      end
      #resources :payments,:only => [:new, :create, :index, :destroy], :shallow =>true
      resources :payments,  :shallow =>true do  
        collection do
          delete :delete_multiple
        end      
      end
      
      resource  :reminder, :only => [ :edit, :update, :show]
      resources :comments, :only => [:new, :create, :destroy, :index], :shallow =>true
      resources :invoice_items,  :shallow =>true
      resources :feedbacks, :shallow =>true
      #resources  :schedules#, :only => [:show, :new, :create, :destroy, :edit, :update]
      
    end

    devise_for :users, :controllers => { :invitations => 'users/invitations' }
    #devise_for :users, :controllers => { :invitations => 'users/new_invite' }
    
    resources :users, :except => [:show] #do 
    #  collection do 
    #    get 'new_invite'
    #    post 'invite'
    #  end  
    #end
    
    resource :company, :only => [:edit, :update, :show] do
      resource :etemplate, :only => [:edit, :update], :shallow =>true  
      resource :preference, :only => [:edit, :update], :shallow => true
    end
    
    resources :clients do 
      collection do
        delete :delete_multiple
      end
      member do
          put 'invite'
      end
      resources :contacts do#, :shallow =>true do  
        member do
          put 'invite'
          get 'new_invite'                            
        end
      end
    end
    
    resource :dashboard do 
      member do 
        get 'show'
    #    post 'invite'
      end  
    end
    
    
    resources :plans, :only => [:index]
    
    resource :subscription

    

    
    root :to => "dashboard#show"

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
