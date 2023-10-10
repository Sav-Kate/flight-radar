class FlightNumberUtility
    def valid_flight_numbers(flight_number)
        if is_flight_number_valid?(flight_number)
            return [flight_number]
        end
        
        valid_flight_numbers_array = []
        formatted_number = remove_white_spaces(flight_number)

        if is_flight_number_valid?(formatted_number)
            valid_flight_numbers_array << formatted_number
        else
            formatted_number = valid_sub_flight_number(formatted_number) 
            valid_flight_numbers_array << formatted_number if formatted_number
        end

        if formatted_number
            numbers_with_zero = add_zero_to_flight_number(formatted_number)
            valid_flight_numbers_array.concat(numbers_with_zero)
        end
        valid_flight_numbers_array.uniq
    end

    private

    def is_flight_number_valid?(flight_number)
        Regex.valid_flight_number.match?(flight_number) ? true : false
    end

    def remove_white_spaces(flight_number)
        flight_number.match?(/\s/) ? flight_number.gsub(/\s/, "") : flight_number
    end

    def valid_sub_flight_number(flight_number)
        sub_number_regex = /^[a-zA-Z0-9]{2,3}[0-9]{1,4}/
        return flight_number.match?(sub_number_regex) ? flight_number.match(sub_number_regex)[0] : nil
    end

    def add_zero_to_flight_number(flight_number)
        zero_if_iata = add_zero_if_iata_code(flight_number)
        zero_if_icao = add_zero_if_icao_code(flight_number)

        [zero_if_iata, zero_if_icao]
    end

    def add_zero_if_iata_code(flight_number)
        iata_code_part = flight_number[0..1]
        number_part = flight_number[2..flight_number.size]
        formatted_number = flight_number

        while formatted_number.size < 6
            iata_code_part << "0"
            formatted_number = iata_code_part + number_part
        end
        formatted_number
    end

    def add_zero_if_icao_code(flight_number)
        icao_code_part = flight_number[0..2]
        number_part = flight_number[3..flight_number.size]
        formatted_number = flight_number

        while formatted_number.size < 7
            icao_code_part << "0"
            formatted_number = icao_code_part + number_part 
        end
        formatted_number
    end
end