module UsersHelper

  def filter_private_goals(goals)
    goals.where(private_goal: false)
  end
end
