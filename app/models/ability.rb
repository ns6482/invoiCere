class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
 
    if user.roles.size == 0
      can :create, [User, Company] #registration
      can :read, Invoice#preview invoice
    end
 
    if user.role? :admin
      can [:invite], Client
      can [:invite], Contact
      can [:update, :read], Etemplate, :company_id => user.company_id
      can [:update, :read], Preference, :company_id => user.company_id

      can [:update, :read], Setting, :company_id => user.company_id
      can [:create, :read, :update, :invite, :new_invite], User,  :company_id => user.company_id
      #can [:destroy], User, :owner => false,  :company_id => user.company_id
      can [:destroy], User,  :company_id => user.company_id

      can :manage,  [Invoice, InvoiceItem, Payment, Delivery, Send, Reminder, Comment, Contact]
      can [:update, :read], Company, :id => user.company_id
      can :manage, Client, :company_id => user.company_id      
      can :read, Role
      can [:read, :destroy], Feedback
      can [:create, :update], Feedback #TODO only apply to client once setup
      can [:manage], Schedule
      can [:manage], Item, :company_id => user.company_id
    elsif user.role? :standard
      cannot [:invite], Client
      cannot [:invite], Contact

      can [:create, :update, :read, :destroy], [Invoice, InvoiceItem, Delivery, Send, Reminder, Payment]
      #can :destroy, [Invoice, InvoiceItem]
      can [:create, :update, :read], [Client, Contact], :company_id => user.company_id
      can [:update, :read], User,:id => user.id
      can :read, Company, :id => user.company_id
      can :read, Setting, :id => user.company_id
      can [:create, :read], Comment      
      can :destroy, Comment, :user_id => user.id
      can [:read, :destroy], Feedback
      can [:create, :update], Feedback #TODO only apply to client once setup
      can [:read, :update], Schedule
      can :read, Role
    elsif user.role? :viewer
      can [:read], [Invoice, InvoiceItem, Delivery, Send, Reminder, Payment, Feedback]
      can [:read], [Client], :company_id => user.company_id
      can [:read], [Contact]
      can [:update, :read], User,:id => user.id
      can :read, Company, :id => user.company_id
      can :read, Setting, :id => user.company_id
      can [:create, :read], Comment
      can :delete, Comment, :id => user.id
      can [:read], Schedule
    elsif user.role? :client
      can [:read], Company, :id => user.company_id
      can [:read, :update], Client, :id => user.client_id
      can [:manage], Comment, :user_id => user.email
      can [:manage], Contact, :client_id => user.client_id
      can [:update, :read], User, :id => user.id
      can [:read], Invoice, :client_id => user.client_id
      can [:read, :create, :update], Feedback #TODO only apply to client once setup
      can [:create], Payment
    end
  end
  
end
