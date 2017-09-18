FactoryGirl.define do
  factory :location, :class => GeoLocation::Location  do
    ip_address {Faker::Internet.ip_v4_address}
    city { Faker::Lorem.word }
    country { Faker::Lorem.word }
    country_code {Faker::Lorem.word}
    latitude { Faker::Number.decimal(3, 3) }
    longitude { Faker::Number.decimal(3, 3) }
  end
end