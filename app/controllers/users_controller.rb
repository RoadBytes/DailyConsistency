class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def welcome
    redirect_to home_path if current_user
  end

  def show
    # TODO: move .get_note to User model
    @note  = Note.get_note(day: Date.today, user: current_user )
  end
 
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome, you are now registered"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def current_note_param
    params.permit(:id)
  end
end
