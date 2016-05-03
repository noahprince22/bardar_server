Fabricator(:user) do
  user_id { Faker::Name.name }
end

Fabricator(:bar) do
  yelp_id { Faker::Company.name }
  name { Faker::Company.name }
  latitude { Faker::Address.latitude }
  longitude { Faker::Address.latitude }
end

Fabricator(:report) do
  line_length { Faker::Number.between(0, 9) }
  cover_charge { Faker::Number.between(0, 9) }
  ratio { Faker::Number.decimal(0, 2) }
  avg_age { Faker::Number.between(18, 100) }
  crowd { Faker::Number.between(0, 9) }
  bar
  user
  is_upvote { Faker::Boolean.boolean }
  is_current false
  created_at { Faker::Time.between(1.day.ago, Time.now) }
end