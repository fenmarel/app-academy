class SubsController < ApplicationController
  before_filter :redirect_if_not_logged_in
  before_filter :require_moderator, :only => [:edit, :destroy, :update]

  def new
    @sub = Sub.new
    3.times { @sub.links.build }
  end

  def create
    @sub = current_user.subs.new(sub_params)
    @sub.links.build(link_params)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      (3 - links_params.count).times { @post.links.build }
      render :new
    end
  end


  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def destroy

  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])

    if @sub.update_attributes(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  private

  def require_moderator
    sub = Sub.find(params[:id])
    unless current_user.is_moderator_of(sub)
      redirect_to sub_url(sub)
    end
  end

  def sub_params
    params.require(:sub).permit(:name)
  end

  def link_params
    params.permit(links: [:title, :url, :body])
          .require(:links)
          .values
          .reject do |ln|
            ln[:title].blank? && ln[:body].blank? && ln[:url].blank?
          end
  end
end
