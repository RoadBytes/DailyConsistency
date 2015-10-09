class NotesController < ApplicationController
  before_action :require_user

  def index
    @notes = current_user.set_notes
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def update
    @note = Note.find_by(id_param)
    if @note.update(note_body_param)
      flash[:success] = "Note Saved"
      redirect_to home_path
    else
      flash[:error] = "Sorry there has been an error"
      redirect_to :back
    end
  end

  def show
    @note = Note.find_by(id_param)
    redirect_to home_path unless current_user.notes.include?(@note)
  end

  private

  def note_body_param
    params.require(:note).permit(:body)
  end

  def id_param
    params.permit(:id)
  end
end
