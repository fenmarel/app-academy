class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @feeds }
    end
  end

  def create
    feed = Feed.find_or_create_by_url(feed_params[:url])
    if feed
      render :json => feed
    else
      render :json => { error: "invalid url" }, status: :unprocessable_entity
    end
  end

  def show
    feed = Feed.find(params[:id])
    if feed.reload
      render :json => feed.to_builder.target!
    else
      render :json => { status: 422 }
    end
  end

  private
  def feed_params
    params.require(:feed).permit(:title, :url)
  end
end
