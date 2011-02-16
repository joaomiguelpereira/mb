class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserMailer.activation_email(user).deliver unless (user.class.name == Staffer.name)
    UserMailer.staffer_activation_email(user).deliver if (user.class.name == Staffer.name && user.notify_on_create)
     
     
  end
  
end
