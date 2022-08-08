FactoryBot.define do
  factory :vendor do
    name { Faker::Name.name}
    description{Faker::Lorem.paragraph }
    online { true }
  end
end
