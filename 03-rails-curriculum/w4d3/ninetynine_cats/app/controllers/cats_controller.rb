class CatsController < ApplicationController
  before_action :check_cat_owner!, only: [:edit, :update]

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :sex, :color, :birthdate, :age)
  end

  def check_cat_owner!
    @cat = Cat.find(params[:id])
    redirect_to root_url unless current_user.id == @cat.user_id
  end

end
