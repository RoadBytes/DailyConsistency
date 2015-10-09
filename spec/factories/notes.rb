require 'faker'

FactoryGirl.define do 
  factory :note do
    body        { Faker::Lorem.sentence }
    user_id     1
    date        Date.today

    created_at  Time.now
    updated_at  Time.now
  end
end
