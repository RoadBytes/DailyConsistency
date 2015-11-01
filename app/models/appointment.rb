class Appointment
  attr_accessor :id, :title, :start_time, :end_time

  def initialize(google_object)
    @id         = google_object.id
    @title      = google_object.title
    @start_time = Time.parse(google_object.start_time)
    @end_time   = Time.parse(google_object.end_time)
  end

  def self.set_calendar

    cal = Google::Calendar.new(
      :client_id     => ENV["YOUR_CLIENT_ID"],
      :client_secret => ENV["YOUR_SECRET"],
      :calendar      => ENV["YOUR_CALENDAR_ID"],
      :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
    )
    cal.login_with_refresh_token(ENV["REFRESH_TOKEN"])
    cal
  end

  def self.list
    cal = Appointment.set_calendar

    cal.find_future_events().map! do |event|
      Appointment.new(event)
    end
  end

  def self.find_appointment(search_id)
    Appointment.list.each do |appointment| 
      return appointment if appointment.id == search_id
    end
  end

  def self.grouped_appointments(time_zone = nil)
    if time_zone.nil?
      list.group_by{|appointment| appointment.start_time.to_date}
    else
      list.group_by{|appointment| appointment.start_time.in_time_zone(time_zone).to_date}
    end
  end
end
