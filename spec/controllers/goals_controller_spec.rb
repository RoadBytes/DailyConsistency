require 'spec_helper'

describe GoalsController do
  let(:authenticated_user) { create(:user) }

  describe "GET #goals" do
    context "with authenticated user" do
      before :each do
        session[:user_id] = authenticated_user.id
        get :goals
      end

      it "sets @goals to user's goals" do
        expect(assigns(:goals)).to eq authenticated_user.goals
      end

      it "sets @note for current day" do
        expect(assigns(:note).date).to eq(Date.today.to_datetime)
      end

      it "renders goals template" do
        expect(response).to render_template :goals
      end
    end

    it "redirects to root_path with unauthenticated user" do
      get :goals
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #new" do
    it "sets @goal" do
      session[:user_id] = authenticated_user.id
      get :new
      expect(assigns(:goal)).to be_instance_of(Goal)
    end
  end

  describe "POST #create" do
    context "with authenticated user" do
      before :each do
        session[:user_id] = authenticated_user.id
      end

      context "with invalid input" do
        before :each do
          post :create, goal: { description: "" }
        end

        it "does not save to database" do
          expect(Goal.count).to eq 0
        end

        it "has a flash error message" do
          expect(flash[:error]).to_not be_empty
        end

        it "renders :new" do
          expect(response).to render_template(:new)
        end
      end

      context "with valid input" do
        before :each do
          post :create, goal: { description: "Be a profession Rails Developer" }
        end

        it "saves @goal to db" do
          expect(Goal.count).to eq 1
        end

        it "sets user_id to current_user.id" do
          expect(Goal.first.user_id).to eq authenticated_user.id
        end

        it "has a flash success message" do
          expect(flash[:success]).to_not be_blank
        end

        it "redirects to goals_path" do
          expect(response).to redirect_to goals_path
        end
      end
    end
  end

  describe "GET #edit" do
    it "sets @goal for current_user" do
      session[:user_id] = authenticated_user.id
      goal_to_edit      = create(:goal, user_id: authenticated_user.id)
      get :edit, id: goal_to_edit.id
      expect(assigns(:goal)).to eq goal_to_edit
    end

    it "redirects for unauthenticated users" do
      goal_to_edit = create(:goal, user_id: authenticated_user.id)
      get :edit, id: goal_to_edit.id
      expect(response).to redirect_to root_path
    end

    it "redirects for non associated users"
      other_user   = create(:user)
      session[:user_id] = other_user.id
      goal_to_edit = create(:goal, user_id: authenticated_user.id)
      get :edit, id: goal_to_edit.id
      expect(response).to redirect_to goals_path
  end
end
