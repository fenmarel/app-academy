class MultiSessionsController < ApplicationController

  def new

  end

  def create

  end

  def destroy
    @multi_session = MultiSession.find(params[:id])
    @multi_session.destroy

    redirect_to root_url
  end

end
