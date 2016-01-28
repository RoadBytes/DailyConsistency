class Appointment < Google::Calendar
  def self.calendar
    if calendar_stale?
      @calendar = Google::Calendar.new(
        :client_id     => ENV["YOUR_CLIENT_ID"],
        :client_secret => ENV["YOUR_SECRET"],
        :calendar      => ENV["YOUR_CALENDAR_ID"],
        :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
      )
      @calendar.login_with_refresh_token(ENV["REFRESH_TOKEN"])
    end
    @calendar
  end
  
  def self.find_appointment(search_id)
    Appointment.calendar.find_event_by_id(search_id)
  end

  def self.list(time_zone = "UTC")
    Appointment.calendar.find_future_events.group_by do |appointment| 
      appointment.start_time.in_time_zone(time_zone).strftime("%F")
    end
  end

  def self.update(user_name, user_email, search_id)
    Appointment.calendar.find_or_create_event_by_id(search_id) do |event|
      event.title     = "Meeting with #{user_name}"
      event.attendees = [
        { 'email'          => user_email, 
          'displayName'    => user_name, 
          'responseStatus' => 'accepted'}]
      event.reminders = {
        'useDefault' => false, 
        'overrides'  => ['minutes' => 60, 
                        'method' => 'email']}
      event.extended_properties = {'shared' => {'sendNotifications' => 'true'}}
    end.save

    Appointment.event_status(search_id)
  end

  private

  def self.calendar_stale?
    # expire @calendar every five minutes
    @calendar_refreshed_at ||= Time.now
    @calendar.blank? || (Time.now - @calendar_refreshed_at > 5.minutes)
  end
  

  def self.event_status(id)
    Appointment.find_appointment(id).first.title != "available"
  end
end
