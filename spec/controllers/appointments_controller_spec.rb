require 'spec_helper'

describe AppointmentsController do
  describe "GET index" do
    it "sets @appointments" do
      get :index
      expect(assigns(:appointments)).to be_present
    end
  end

  describe "GET edit" do
    it "sets @appointment" do
      event_id = Appointment.list.values.first[0].id
      get :edit, id: event_id
      expect(assigns(:appointment)).to be_present
    end
  end

  # how to test update
end
