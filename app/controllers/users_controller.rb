class UsersController < ApplicationController
  def welcome
    redirect_to goals_path if current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome, you are now registered"
      session[:user_id] = @user.id
      redirect_to goals_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

end
