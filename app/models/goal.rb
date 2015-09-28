class Goal < ActiveRecord::Base
  validates :description, presence: true

  has_many :habits

  def habit= habit_argument
    habits << habit_argument unless habits.include? habit_argument
  end
end
