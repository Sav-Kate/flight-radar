class Regex
    def self.valid_flight_number
        /\A[A-Z0-9]{2,3}[0-9]{1,4}\z/
    end

    def self.valid_iata
        /\A[A-Z]{3}\z/
    end
end