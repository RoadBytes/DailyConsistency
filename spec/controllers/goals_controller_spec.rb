require 'spec_helper'

describe GoalsController do
  let(:authenticated_user) { create(:user) }
  let(:other_user)         { create(:user) }

  describe "GET #new" do
    it "sets @goal" do
      session[:user_id] = authenticated_user.id
      get :new
      expect(assigns(:goal)).to be_instance_of(Goal)
    end

    it "sets @habit" do
      session[:user_id] = authenticated_user.id
      get :new
      expect(assigns(:habit)).to be_instance_of(Habit)
    end

    it "redirects to root_path for unauthenticated users" do
      get :new
      expect(response).to redirect_to root_path
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

        it "redirects to home_path" do
          expect(response).to redirect_to home_path
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

    context "for non associated users" do
      before :each do
        other_user   = create(:user)
        session[:user_id] = other_user.id
        goal_to_edit = create(:goal, user_id: authenticated_user.id)
        get :edit, id: goal_to_edit.id
      end

      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end

      it "sets flash[:error] message" do
        expect(flash[:error]).to_not be_empty
      end
    end
  end

  describe "PUT or PATCH #update" do
    before :each do
      session[:user_id] = authenticated_user.id
      @goal = create(:goal, user_id: authenticated_user.id)
    end

    context "valid attributes" do
      before :each do
        put :update, id: @goal.id, goal: attributes_for(:goal, description: "Kick Coding Ass")
      end

      it "located the requested @goal" do
        expect(assigns(:goal)).to eq @goal
      end

      it "changes @goal's attribute" do
        @goal.reload
        expect(@goal.description).to eq "Kick Coding Ass"
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
      end
    end

    context "invalid attributes" do
      before :each do
        put :update, id: @goal.id, goal: attributes_for(:goal, description: "")
      end
      it "locates the requested @goal" do
        expect(assigns(:goal)).to eq(@goal)
      end

      it "does not change @goal's attributes" do
        @goal.reload
        expect(@goal.description).to_not eq("")
      end

      it "re-renders the edit method" do
        expect(response).to render_template :edit
      end
    end

    context "unassociated user" do
      it "redirects to goals path" do
        goal_to_edit = create(:goal, user_id: other_user.id)
        put :update, id: goal_to_edit.id, goal: attributes_for(:goal)
        expect(response).to redirect_to home_path
      end
    end

    context "unauthenticated user" do
      it "redirects to root_path" do
        session[:user_id] = nil
        put :update, id: @goal.id, goal: attributes_for(:goal, description: "Kick Coding Ass")
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "authenticated user" do
      before :each do
        session[:user_id] = authenticated_user.id
        @goal = create(:goal, user_id: authenticated_user.id)
        delete :destroy, id: @goal.id
      end

      it "should remove goal from db" do
        expect(Goal.all.size).to eq 0
      end

      it "redirects to home_path" do 
        expect(response).to redirect_to home_path
      end
    end

    context "non associated user" do
      it "does not delete non current_user queue items" do
        session[:user_id] = authenticated_user.id
        @other_users_goal = create(:goal, user_id: other_user.id)
        delete :destroy, id: @other_users_goal.id
        expect(Goal.all.size).to eq 1
      end

      it "redirects to root_path for unauthenticated users" do
        @goal = create(:goal, user_id: authenticated_user.id)
        delete :destroy, id: @goal.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
