FactoryBot.define do
  factory :event do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 50) }
    location { Faker::Nation.capital_city }
    start_date { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 1) }
    end_date { Faker::Time.between(from: DateTime.now + 2, to: DateTime.now + 2) }
    user
  end
end