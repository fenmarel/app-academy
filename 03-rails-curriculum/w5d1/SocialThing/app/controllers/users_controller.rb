class UsersController < ApplicationController
  def new
    @user = User.new
    @links = Array.new(3) { Link.new }

    render :new
  end

  def create
    @user = User.new(user_params)
    unless post_params[:body].blank?
      @post = @user.posts.build(post_params)
      @post.links.build(link_params)
    end

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def forgot_password
    @user = User.find(params[:id])
    if @user.reset_token == params[:token]
      render :forgot_password
    else
      flash[:errors] = "HACKER ALERT!!!"
      redirect_to new_session_url
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :forgot_password
    end
  end

  def feed
    @user = User.find(params[:id])

    @posts = Post.find_by_sql(<<-SQL)
    SELECT DISTINCT
      posts.*
    FROM
      posts
    JOIN post_shares
      ON posts.id = post_shares.post_id
    JOIN friend_circles
      ON post_shares.friend_circle_id = friend_circles.id
    JOIN friend_circle_memberships
      ON friend_circle_memberships.friend_circle_id = friend_circles.id
    WHERE
      friend_circle_memberships.user_id = #{@user.id}
    SQL

    render :feed
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def post_params
    params.require(:user).require(:post).permit(:body)
  end

end
