class SecretsController < ApplicationController

  def new
    @secret = Secret.new
  end

  def create
    @secret = current_user.authored_secrets.build(secret_params)

    respond_to do |format|
      if @secret.save
        format.html { redirect_to user_url(secret_params[:recipient_id]) }
        format.json { render :json => @secret }
      else
        format.html do
          flash.now[:errors] = @secret.errors.full_messages
          render :new
        end

        format.json { render :json => @secret.errors, status: 422 }
      end
    end
  end


  private

  def secret_params
    params.require(:secret).permit(:recipient_id, :title, :tag_ids => [])
  end
end
