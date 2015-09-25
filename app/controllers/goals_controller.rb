class GoalsController < ApplicationController
  before_action :require_user

  def goals
    @goals = current_user.goals
    @note  = Note.get_note(day: Date.today, user: current_user.id)
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params.merge!(user_id: current_user.id))
    if @goal.save
      flash[:success] = "Goal was saved!"
      redirect_to goals_path
    else
      flash[:error] = "Goal was not saved."
      render "goals/new"
    end
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
  end

  private

  def goal_params
    params.require(:goal).permit(:description)
  end
end
