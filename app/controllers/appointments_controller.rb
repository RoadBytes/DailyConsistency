class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.grouped_appointments session[:time_zone]
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
    time_object = ActiveSupport::TimeZone[params["selected_time_zone"]]
    session[:time_zone] = time_object.name
    @appointments = Appointment.grouped_appointments session[:time_zone]
    render "index"
  end
end
