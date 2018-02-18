FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email "seun@adekunle.com"
    password "adekunle"
  end
end
