class Flight < ApplicationRecord
    validates :number, presence: true, uniqueness: true

    has_many :flight_legs
    has_many :departure_airports, through: :flight_legs
    has_many :arrival_airports, through: :flight_legs
end
