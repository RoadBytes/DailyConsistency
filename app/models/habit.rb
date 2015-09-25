class Habit < ActiveRecord::Base
  validates :description, presence: true
end
