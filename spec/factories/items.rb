FactoryBot.define do
  factory :item do
    name { Faker::StarWars.character }
    bucketlist_id nil
  end
end
