require 'faker'

FactoryGirl.define do 
  factory :goal do
    description { Faker::Lorem.sentence }

    created_at  Time.now
    updated_at  Time.now
  end 
end
