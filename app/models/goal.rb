class Goal < ActiveRecord::Base
  validates :description, presence: true

  has_many :habits
end
