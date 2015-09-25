require 'spec_helper'

describe Note do
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:date) }

  describe ".get_note(day: date_argument, user: user_argument)" do

    context "Without a preexisting note" do
      let(:note) { Note.get_note(day: Date.today, user: 1) }

      it "returns a Note object" do
        expect(note).to be_a Note
      end

      it "returns note with date equal to date_argument" do
        expect(note.date).to eq(Date.today.to_datetime)
      end

      it "returns note with user_id equal to user_argument" do
        expect(note.user_id).to eq(1)
      end

      it "returns note with body equal to nil when user doesn't have a note for that day" do
        expect(note.body).to eq(nil)
      end
    end

    it "returns note that belongs to user" do
      new_user             = create(:user, id: 2)
      preexisting_note = create(:note, date: Date.today.to_datetime, user_id: new_user.id)

      note = Note.get_note(day: Date.today, user: 2)
      expect(note.id).to eq(preexisting_note.id)
    end
  end
end
