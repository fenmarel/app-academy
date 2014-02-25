class PostsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @circles = @user.friend_circles
    @post = Post.new
    @links = Array.new(3) { Link.new }

    render :new
  end

  def create
    @user = User.find(params[:user_id])
    @post = Post.new(post_params)
    @post.links.build(link_params)


    if @post.save
      redirect_to user_post_url(@post.author, @post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to new_user_post_url
    end
  end

  def show
    @post = Post.find(params[:id])
    @links = @post.links

    render :show
  end


  private

  def post_params
    params.require(:post).permit(:body, :user_id, :friend_circle_ids => [])
  end
end


