class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    
    
      #puts "ClassName: "+user.class.name
      #puts "ClassName: "+user.email
      #puts "createdByNil? #{user.created_by.nil?}: "
      #puts "createdByNil:  #{user.created_by}: "
      #puts "notifyOnCreate #{user.notify_on_create}: "
      
      
      
      UserMailer.admin_activation_email(user).deliver if (user.class.name == BusinessAdmin.name && !user.created_by.nil? && user.notify_on_create)
      
      UserMailer.staffer_activation_email(user).deliver if (user.class.name == Staffer.name && user.notify_on_create)
      
    
      UserMailer.activation_email(user).deliver if (user.class.name == User.name || (user.class.name == BusinessAdmin.name && user.created_by.nil?) )
    
    
    
    
    #UserMailer.activation_email(user).deliver unless (user.class.name == Staffer.name)
    #UserMailer.staffer_activation_email(user).deliver if (user.class.name == Staffer.name && user.notify_on_create)
    
    
    
  end
  
end
