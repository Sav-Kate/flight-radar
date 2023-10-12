FactoryBot.define do
  factory :airport do
    iata    { "TES" }
    city    { "City" }
    country   { "Country" }
    latitude    { 12.34 }
    longitude   { 23.56 }
  end
end
