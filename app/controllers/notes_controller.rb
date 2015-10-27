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
    @note = Note.where(id: id_param).first
    # @note = Note.where(id: params[:id], user_id: current_user.id ).first
    redirect_to home_path if @note.blank?
    # unless current_user.notes.include?(@note)
  end

  private

  # TODO: consider name: strong_note_params
  def note_body_param
    params.require(:note).permit(:body)
  end

  # TODO: consider name: strong_note_params
  def id_param
    params.permit(:id)
  end
end
