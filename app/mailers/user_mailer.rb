class UserMailer < ActionMailer::Base  
  default :from => Application::config['mail_notifications']['default_mail_from']
  
  
  
  def activation_email(user)
    @user = user
    @url = activate_user_url(:activationKey=>user.activation_key)
    mail(:to=>user.email, :subject=>I18n.t("mailer.user.activation.subject") )
  end
end
