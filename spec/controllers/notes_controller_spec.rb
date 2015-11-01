require 'spec_helper'

describe NotesController do
  let(:authenticated_user) { create(:user) }

  describe "GET #index" do
    context "for authenticated users" do
      before :each do
        session[:user_id] = authenticated_user.id
        create(:note, user_id: authenticated_user.id)
        get :index
      end

      it "sets @notes to user.set_notes" do
        expect(assigns(:notes)).to eq(authenticated_user.set_notes)
      end
    end
  end

  describe "GET #show" do
    context "for authenticated users" do
      it "sets @note" do
        session[:user_id] = authenticated_user.id
        note = create(:note, user_id: authenticated_user.id)
        get :show, id: note.id
        expect(assigns[:note]).to eq note
      end

      it "redirects to home_path for view of other users' notes" do
        session[:user_id] = authenticated_user.id
        note = create(:note, user_id: 3)
        get :show, id: note.id
        expect(response).to redirect_to home_path
      end
    end
  end
end
