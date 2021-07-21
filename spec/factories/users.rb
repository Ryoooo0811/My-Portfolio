FactoryBot.define do
  factory :user do
    name { Faker::Name.last_name }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number: 50) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
