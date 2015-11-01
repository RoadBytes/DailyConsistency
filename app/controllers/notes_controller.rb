class NotesController < ApplicationController
  before_action :require_user

  def index
    @notes = current_user.set_notes
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def update
    @note = Note.where(id_param).first
    if @note.update(strong_note_params)
      flash[:success] = "Note Saved"
      redirect_to home_path
    else
      flash[:error] = "Sorry there has been an error"
      redirect_to :back
    end
  end

  def show
    @note = Note.where(id_param).first
    redirect_to home_path if @note.user_id != current_user.id
  end

  private

  def strong_note_params
    params.require(:note).permit(:body)
  end

  def id_param
    params.permit(:id)
  end
end
