require 'spec_helper'

describe Goal do
  it { should validate_presence_of(:description) }

  it { should have_many(:habits) }

  describe "#habit=" do
    let (:goal)  {create(:goal)}
    let (:habit) {create(:habit)}

    it "associates goal to habit" do
      goal.habit= habit
      expect(goal.habits).to include habit
    end

    it "doesn't duplicate association" do
      goal.habit= habit
      goal.habit= habit
      expect(goal.habits.size).to eq 1
    end
  end
end
