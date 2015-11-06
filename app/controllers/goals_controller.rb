class GoalsController < ApplicationController
  before_action :require_user

  def new
    @goal  = Goal.new
    @habit = Habit.new
  end

  def create
    @goal = Goal.new(goal_params.merge!(user_id: current_user.id))
    if @goal.save
      flash[:success] = "Goal was saved!"
      redirect_to home_path
    else
      flash[:error] = "Goal was not saved!"
      render :new
    end
  end
 
  def edit
    @goal = Goal.find_by(id: params[:id])
    if @goal.user_id != current_user.id
      flash[:error] = "Action Not Allowed"
      redirect_to home_path
    end
  end

  def update
    @goal  = Goal.find_by(id: params[:id])
    if @goal.update(goal_params)
      redirect_to home_path
    else
      render :edit
    end
  end

  def destroy
    goal = Goal.find_by(id: params[:id])
    goal.delete if goal.user_id == current_user.id
    redirect_to home_path
  end

  private

  def goal_params
    params.require(:goal).permit(:description, :habit)
  end
end
