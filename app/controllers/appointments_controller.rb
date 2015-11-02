class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.grouped_appointments session[:time_zone]
  end

  def edit
    @appointment = Appointment.find_appointment(params[:id])
  end

  def update
    name       = params["name"]
    user_email = params["user_email"]

    cal = Appointment.set_calendar
    appointment = cal.find_or_create_event_by_id(params[:id]) do |e|
      e.title = name
      e.attendees = [
        { 'email' => user_email, 
          'displayName' => name, 
          'responseStatus' => 'accepted' }
        ]
      e.reminders = {'useDefault'  => false, 'overrides' => ['minutes' => 60, 'method' => "email"]}
      e.extended_properties = {'shared' => {'sendNotifications' => 'true'}}
    end

    appointment.save

    flash[:success] = "Great #{name}, I'll email a hangout link when I see the appointment."
    redirect_to appointments_path
  end

  def set_time_zone
    time_object = ActiveSupport::TimeZone[params["selected_time_zone"]]
    session[:time_zone] = time_object.name
    @appointments = Appointment.grouped_appointments session[:time_zone]
    render "index"
  end
end
