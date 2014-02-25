class UserMailer < ActionMailer::Base
  default from: "coolkids@appacademy.io"

  def password_reset(user)
    @user = user
    @url = "http://localhost:3000/users/#{@user.id}/forgot_password?token=#{@user.reset_token}".html_safe
    mail(to: @user.email, subject: "Fool, reset yo password.")
  end

end
