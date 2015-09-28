class HabitsController < ApplicationController
  before_action :require_user

  def create
    Habit.create(habit_params)
    redirect_to goals_path
  end

  def edit
    @goal  = Goal.find_by( id: params[:goal_id])
    @habit = Habit.find_by(id: params[:id])
  end

  def update
    @habit  = Habit.find_by(id: params[:id])
    if @habit.update(habit_params)
      redirect_to goals_path
    else
      render :edit
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:description).merge!(goal_id: params[:goal_id])
  end
end
