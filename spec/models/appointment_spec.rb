require 'spec_helper'

describe Appointment do
  describe ".calendar" do
    it "returns a calendar" do
      allow(Appointment).to receive(:calendar_stale?).and_return(true)
      calendar = Appointment.calendar
      expect(calendar).to be_a Google::Calendar
    end

    it "preserves calendar object if not stale" do
      allow(Appointment).to receive(:calendar_stale?).and_return(true)
      calendar = Appointment.calendar
      
      allow(Appointment).to receive(:calendar_stale?).and_return(false)
      new_calendar = Appointment.calendar
      expect(new_calendar.object_id).to eq calendar.object_id
    end

    # check stale feature
    # mock stale method
    #   check same by #object_id method
    #   allow to receive
    # allow(Appointment).to receive(:calendar_stale?).and_return(false)
      # expect(Appointment.calendar).to be_a Google::Calendar
  end

  describe ".find_appointment" do
    context "with existing appointment" do
      it "returns the Google::Event in an array" do
        event_id = Appointment.list.values.first[0].id
        expect(Appointment.find_appointment(event_id)[0]).to be_a Google::Event
      end
    end

    context "with non existing appointment" do
      it "returns an empty array" do
        expect(Appointment.find_appointment("none")).to eq []
      end
    end
  end

  describe ".list" do
    it "returns a hash with values that are arrays of Google::Events" do
      returned_list = Appointment.list
      expect(returned_list).to be_a Hash
      expect(returned_list.values.first[0]).to be_a Google::Event
    end
  end

  # make test calendar...
  # or, have mock old appointment
  # How do I test update? Would I need to actually change my calendar?
  describe ".update(user_name, user_email, search_id)" do
    # context "with valid data" do
    #   it "changes the existing appointment" do
    #     appointment = Appointment.update("Jason", "test@test.com", id))
    #     expect(appointment.displayName).to eq "Jason"
    #   end
    # end
    # context "with invalid data" do
    # end
  end
end
