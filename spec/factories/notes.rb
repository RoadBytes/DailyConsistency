require 'faker'

FactoryGirl.define do 
  factory :note do
    body        { Faker::Lorem.sentence }
    user_id     1

    created_at  Time.now
    updated_at  Time.now
  end
end
