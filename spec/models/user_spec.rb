require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }
  it { validate_length_of(:password).is_at_least(6) }

  it { should have_many(:goals) }
  it { should have_many(:notes).order(:date) }

  describe "#authenticate" do
    it "should return object when password is correct" do
      joe = create(:user, password: "123456")
      expect(joe.authenticate("123456")).to eq(joe)
    end

    it "should return false when password is correct" do
      joe = create(:user, password: "123456")
      expect(joe.authenticate("wrong password")).to eq(false)
    end
  end

  # There is also this concept of User and only getting notes from current_user.  Should I put that logic in Note model?
  let(:logged_in_user)  { create(:user) }
  let(:first_note)      { create(:note, date: (Date.today - 1)) }
  let(:last_note)       { create(:note, date: (Date.today)) }

  before :each do
    logged_in_user.notes << first_note
    logged_in_user.notes << last_note
  end

  describe "#next_note(current_note)" do
    it "returns note of next future day if it exists" do
      expect(logged_in_user.next_note(first_note)).to eq last_note
    end

    it "returns current_note if next day note doesn't exists" do
      expect(logged_in_user.next_note(last_note)).to eq last_note
    end
  end

  describe "#previous_note(current_note)" do
    it "returns note of previous day if it exists" do
      expect(logged_in_user.previous_note(last_note)).to eq first_note
    end

    it "returns current_note if previous day note doesn't exists" do
      expect(logged_in_user.previous_note(first_note)).to eq first_note
    end
  end
end
