class Flight < ApplicationRecord
    validates :number, presence: true, uniqueness: true
end
