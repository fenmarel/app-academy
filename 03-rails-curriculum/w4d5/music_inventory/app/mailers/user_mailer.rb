class UserMailer < ActionMailer::Base
  default from: "do-not-reply@music-inventory.com"

  def activation_email(user)
    @user = user
    @url = "#{activate_users_url}?activation_token=#{user.activation_token}"

    mail(to: user.email, subject: "Welcome! Please Activate your Account")
  end
end
