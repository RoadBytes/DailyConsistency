require 'faker'

FactoryGirl.define do 
  factory :habit do
    description { Faker::Lorem.sentence }
    goal_id     nil

    created_at  Time.now
    updated_at  Time.now
  end
end
