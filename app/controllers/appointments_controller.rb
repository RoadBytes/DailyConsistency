class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.list session[:time_zone]
  end

  def edit
    @appointment = Appointment.find_appointment(params[:id]).first
  end

  def update
    name      = params["name"]
    email     = params["user_email"]
    search_id = params["id"]
    
    if Appointment.update(name, email, search_id)
      flash[:success] = "Great #{name}, I'll email a hangout link when I see the appointment."
    else
      flash[:error]  = "Sorry #{name}, there seems to have been an error. Please try again or email me at 'jason.data@roadbytes.me'"
    end

    redirect_to appointments_path
  end

  def set_time_zone
    time_object = ActiveSupport::TimeZone[params["selected_time_zone"]]
    session[:time_zone] = time_object.name
    @appointments = Appointment.list session[:time_zone]
    render "index"
  end
end
