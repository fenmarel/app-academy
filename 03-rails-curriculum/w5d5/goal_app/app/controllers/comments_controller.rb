class CommentsController < ApplicationController

  def create
    @comment = current_user.authored_comments.new(comment_params)

    if @comment.save
      flash[:errors] = ["Comment successfully added"]
      redirect_to :back
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:errors] = ["Comment deleted"]
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end

end
