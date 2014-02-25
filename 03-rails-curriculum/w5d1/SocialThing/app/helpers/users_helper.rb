module UsersHelper
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
