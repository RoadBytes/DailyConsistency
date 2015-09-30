require 'spec_helper'

describe HabitsController do
  let(:authenticated_user) { create(:user) }
  let(:goal)               { create(:goal, user_id: authenticated_user.id)}

  describe "POST #create" do
    context "with authenticated user" do
      context "with valid data" do
        before :each do
          session[:user_id] = authenticated_user.id
          post :create, goal_id: goal.id, habit: {description: "be awesome"}
        end

        it "saves habit to database" do
          expect(Habit.all.size).to eq 1
        end

        it "sets @habit.goal_id as goal.id" do
          expect(Habit.first.goal_id).to eq(goal.id)
        end

        it "redirects_to home_path" do
          expect(response).to redirect_to home_path
        end
      end

      it "doesn't save habit with no description" do
        session[:user_id] = authenticated_user.id
        post :create, goal_id: goal.id, habit: {description: ""}
        expect(Habit.all.size).to eq 0
      end
    end

    it "redirects to root_path for unauthenticated users" do
      post :create, goal_id: goal.id, habit: {description: "be amazingly awesome"}
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #edit" do
    context "authenticated user" do
      before :each do
        session[:user_id] = authenticated_user.id
        @habit_to_edit      = create(:habit, goal_id: goal.id)
        get :edit, goal_id: goal.id, id: @habit_to_edit.id
      end

      it "sets @goal to goal for associated goal" do
        expect(assigns(:goal)).to eq goal
      end

      it "sets @habit" do
        expect(assigns(:habit)).to eq @habit_to_edit
      end
    end

    it "redirects to root_path for unauthenticated users" do
      habit_to_edit      = create(:habit, goal_id: goal.id)
      get :edit, goal_id: goal.id, id: habit_to_edit.id
      expect(response).to redirect_to root_path
    end
  end

  describe "PUT or PATCH #update" do
    context "authenticated user with valid attributes" do
      before :each do
        session[:user_id] = authenticated_user.id
        @habit = create(:habit, goal_id: goal.id, description: "Be sucky")
        put :update, goal_id: goal.id, id: @habit.id, habit: attributes_for(:habit, description: "Kick Coding Ass")
      end

      it "located the requested @habit" do
        expect(assigns(:habit)).to eq @habit
      end

      it "changes @habits's attribute" do
        @habit.reload
        expect(@habit.description).to eq "Kick Coding Ass"
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
      end
    end

    context "authenticated user with invalid attributes" do
      before :each do
        session[:user_id] = authenticated_user.id
        @habit = create(:habit, goal_id: goal.id, description: "Be sucky")
        put :update, goal_id: goal.id, id: @habit.id, habit: attributes_for(:habit, description: "")
      end

      it "locates the requested @habit" do
        expect(assigns(:habit)).to eq(@habit)
      end

      it "does not change @goal's attributes" do
        @habit.reload
        expect(@habit.description).to_not eq("")
      end

      it "re-renders the edit method" do
        expect(response).to render_template :edit
      end
    end

    context "unauthenticated user" do
      it "redriects to root_path" do
        @habit = create(:habit, goal_id: goal.id, description: "Be sucky")
        put :update, goal_id: goal.id, id: @habit.id, habit: attributes_for(:habit, description: "")
        expect(response).to redirect_to root_path
      end

    end
  end

  describe "DELETE #destroy" do
    context "authenticated user" do
      before :each do
        session[:user_id] = authenticated_user.id
        @habit = create(:habit, goal_id: goal.id)
        delete :destroy, goal_id: goal.id, id: @habit.id
      end

      it "should remove habit from db" do
        expect(Habit.all.size).to eq 0
      end

      it "redirects to home_path" do 
        expect(response).to redirect_to home_path
      end
    end

    context "non associated user" do
      it "does not delete non current_user queue items" do
        session[:user_id]  = authenticated_user.id
        other_user         = create(:user)
        @other_users_goal  = create(:goal, user_id: other_user.id)
        @other_users_habit = create(:habit, goal_id: @other_users_goal.id)
        delete :destroy, goal_id: @other_users_goal.id, id: @other_users_habit.id
        expect(Habit.all.size).to eq 1
      end

      it "redirects to root_path for unauthenticated users" do
        @habit = create(:habit, goal_id: goal.id)
        delete :destroy, goal_id: goal.id, id: @habit.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
