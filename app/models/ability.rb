class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
 
    can :create, [User, Company] #registration
 
    if user.role? :admin
      can [:invite], Client
      can [:update, :read], Setting, :company_id => user.company_id
      can [:create, :read, :update, :invite, :new_invite], User,  :company_id => user.company_id
      can [:destroy], User, :owner => false,  :company_id => user.company_id
      can :manage,  [Invoice, InvoiceItem, Payment, Delivery]#, Send, Reminder, Comment]
      can [:update, :read], Company, :id => user.company_id
      can :manage, [Client, Contact], :company_id => user.company_id      
      can :read, Role
      #can [:read, :destroy], Feedback
      #can [:create, :update], Feedback #TODO only apply to client once setup
      can [:manage], Schedule
    elsif user.role? :standard
      #can [:create, :update, :read], [Invoice, InvoiceItem, Delivery, Send, Reminder, Payment]
      can [:create, :update, :read], [Client, Contact], :company_id => user.company_id
      can [:update, :read], User,:id => user.id
      can :read, Company, :id => user.company_id
      can :read, Setting, :id => user.company_id
      #can [:create, :read], Comment
      #can :destroy, Comment, :user_id => user.id
      #can [:read, :destroy], Feedback
      #can [:create, :update], Feedback #TODO only apply to client once setup
      #can [:read, :update], Schedule
      can :read, Role
    elsif user.role? :viewer
      #can [:read], [Invoice, InvoiceItem, Delivery, Send, Reminder, Payment, Feedback]
      can [:read], [Client,Contact], :company_id => user.company_id
      can [:update, :read], User,:id => user.id
      can :read, Company, :id => user.company_id
      can :read, Setting, :id => user.company_id
      #can [:create, :read], Comment
      #can :delete, Comment, :id => user.id
      #can [:read], Schedule
    elsif user.role? :client
      can [:read, :update], Client, :id => user.client_id
      can [:manage], Contact, :client_id => user.client_id
      can [:update], User, :id => user.id
      #can [:read], Invoice, :client_id => user.client_id
      #can [:read, :create, :update], Feedback #TODO only apply to client once setup
    end
  end
  
end
