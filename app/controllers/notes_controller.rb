class NotesController < ApplicationController
  before_action :require_user

  def update
    @note = Note.find_by(id_param)
    if @note.update(note_body_param)
      flash[:success] = "Note Saved"
      redirect_to goals_path
    else
      flash[:error] = "Sorry there has been an error"
      redirect_to :back
    end
  end

  private

  def note_body_param
    params.require(:note).permit(:body)
  end

  def id_param
    params.permit(:id)
  end
end
