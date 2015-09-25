require 'faker'

FactoryGirl.define do 
  factory :user do
    name       { Faker::Name.name }
    email      { Faker::Internet.email }
    password   "123456"

    created_at Time.now
    updated_at Time.now
  end 
end
