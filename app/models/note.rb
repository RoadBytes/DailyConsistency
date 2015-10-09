class Note < ActiveRecord::Base
  validates  :date, presence: true
  belongs_to :user

  def self.get_note(options = { day: note_date, user: current_user_id })
    @note = Note.find_by(date: options[:day].to_datetime, user_id: options[:user])
    @note.nil? ? Note.create(date: Date.today.to_datetime, user_id: options[:user], body: "") : @note
  end

  def show_date
    date.strftime("%D")
  end

  def emotion
    SadPanda.emotion(self.body)
  end

  def positivity
    SadPanda.polarity(self.body)
  end

  def word_count
    body.split.size
  end
end
