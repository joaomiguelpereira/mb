class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserMailer.activation_email(user).deliver
  end
end
