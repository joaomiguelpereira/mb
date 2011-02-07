class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    puts "Sending mail to: "+user.email
    UserMailer.activation_email(user)
  end
end
