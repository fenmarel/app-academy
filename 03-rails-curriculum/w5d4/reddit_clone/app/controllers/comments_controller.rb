class CommentsController < ApplicationController
  before_filter :redirect_if_not_logged_in

  def new
    @comment = Comment.new

    render :new
  end

  def create
    @link = Link.find(params[:link_id])
    @comment = @link.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to link_url(@link)
    else
      flash[:errors] = @comment.errors.full_messages
      render :new
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:body, :parent_comment_id)
  end
end
