class Note < ActiveRecord::Base
  validates  :date, presence: true
  belongs_to :user

  before_save :default_body_to_empty_string


  def default_body_to_empty_string
    self.body ||= ""
  end

  def self.get_note( args )
    date = args[:date] || Date.today
    user = args[:user]

    note = Note.find_by(date: date.to_datetime, user_id: user.id)
    # TODO: convert to where(date: date.to_datetime, user_id: user.id).first
    # ? operator.... hard to debbug, create body: "" default or 'before_save'
    note || Note.create(date: Date.today.to_datetime, user_id: user.id)
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
