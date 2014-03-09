class SecretsController < ApplicationController

  def new
    @secret = Secret.new
  end

  def create
    @secret = current_user.authored_secrets.build(secret_params)

    if @secret.save
      redirect_to user_url(secret_params[:recipient_id])
    else
      flash[:errors] = @secret.errors.full_messages
      render :new
    end
  end


  private

  def secret_params
    params.require(:secret).permit(:recipient_id, :title)
  end
end
