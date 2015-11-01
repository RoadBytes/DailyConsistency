class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.grouped_appointments Time.zone
  end

  def edit
    @appointment = Appointment.find_appointment(params[:id])
  end

  def update
    cal = Appointment.set_calendar
    appointment = cal.find_or_create_event_by_id(params[:id]) do |e|
      e.title = params["email"]
    end

    appointment.save

    redirect_to appointments_path
  end

  def set_time_zone
    Time.zone = ActiveSupport::TimeZone[params["selected_time_zone"]]
    @appointments = Appointment.grouped_appointments Time.zone
    render "index"
  end
end
