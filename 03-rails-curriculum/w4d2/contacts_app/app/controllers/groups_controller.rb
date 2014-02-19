class GroupsController < ApplicationController
  before_filter :set_group, :only => [:destroy, :update, :show]

  def index
    @groups = Group.groups_for_user_id(params[:user_id])
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      render :json => @group
    else
      render :json => @group.errors.full_messages
    end
  end

  def destroy
    @group.destroy

    render :json => @group
  end

  def show
    @groups = Group.get_members_of_group(params[:id])

    render :json => @groups
  end

  def update
    if @group.update_attributes(group_params)
      render :json => @group
    else
      render :json => @group.errors.full_messages
    end
  end


  private

  def group_params
    params.require(:group).permit(:user_id, :name)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
