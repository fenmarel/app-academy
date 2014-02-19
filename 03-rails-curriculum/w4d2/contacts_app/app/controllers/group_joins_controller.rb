class GroupJoinsController < ApplicationController
  def destroy
    @group_join = GroupJoin.find(params[:id])
    @group_join.destroy

    render :json => @group_join
  end

  def create
    @group_join = GroupJoin.new(join_params)

    if @group_join.save
      render :json => @group_join
    else
      render :json => @group_join.errors.full_messages
    end
  end


  private

  def join_params
    params.require(:group_join).permit(:contact_id, :group_id)
  end

end
