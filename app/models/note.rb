class Note < ActiveRecord::Base
  validates  :date, presence: true
  belongs_to :user

  before_save :default_body_to_empty_string


  def default_body_to_empty_string
    self.body ||= ""
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
