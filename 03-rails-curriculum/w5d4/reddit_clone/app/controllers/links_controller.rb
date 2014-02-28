class LinksController < ApplicationController
  before_filter :redirect_if_not_logged_in
  before_filter :ensure_author_or_mod, :only => [:edit, :update, :destroy]

  def new
    @link = Link.new

    render :new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to link_url(@link)
    else
      flash.now[:errors] = @link.errors.full_messages
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
    @subs = @link.subs
  end

  def update
    @link = Link.find(params[:id])

    ActiveRecord::Base.transaction do
      @link_subs = @link.link_subs

      @link_subs.each do |link_sub|
        unless link_params[:sub_ids].include?(link_sub.id)
          link_sub.destroy
        end
      end

      @link.update(link_params)
    end

    if @link.errors.empty?
      redirect_to link_url(@link)
    else
      flash.now[:errors] = @link.errors.full_messages
      render :edit
    end
  end

  def show
    @link = Link.find(params[:id])
    @parent_comments = @link.parent_comments
    @comment_hash = @link.comments_by_parent_id

    render :show
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    redirect_to subs_url
  end

  def upvote
    @link = Link.find(params[:id])
    @user_vote = UserVote.find_by_user_id_and_link_id(current_user.id, @link.id)

    if @user_vote
      @user_vote.update(:vote => 1)
    else
      @link.user_votes.new(:user_id => current_user.id, :vote => 1)
    end

    @link.save!
    redirect_to link_url(@link)
  end

  def downvote
    @link = Link.find(params[:id])
    @user_vote = UserVote.find_by_user_id_and_link_id(current_user.id, @link.id)

    if @user_vote
      @user_vote.update(:vote => -1)
    else
      @link.user_votes.new(:user_id => current_user.id, :vote => -1)
    end

    @link.save!
    redirect_to link_url(@link)
  end


  private

  def ensure_author_or_mod
    @link = Link.find(params[:id])

    unless current_user == @link.user ||
           current_user.is_moderator_of(@link.sub)

      redirect_to link_url(@link)
    end
  end

  def link_params
    params.require(:link).permit(:title, :body, :url, :sub_ids => [])
  end
end
