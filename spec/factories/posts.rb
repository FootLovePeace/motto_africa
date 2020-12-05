FactoryBot.define do
  factory :post do
    title      {Faker::Name.initials}
    text       {Faker::Lorem.sentence}
    country_id {Faker::Number.within(range: 2..55)}
    genre_id   {Faker::Number.within(range: 2..15)}
    association :user
    
    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end