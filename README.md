## General info

The app has one API '/flight_route/:flight_number', that accepts a flight_number of string type and finds a flight's route information based on it.

Output is a hash in a JSON format.

In case the flight is found, the response of API is:
{
  route: {
    departure: {iata: 'XXX', city: 'YYY', country: 'ZZZ', latitude: 12.34, longitude: 56.78},
    arrival: {iata: 'AAA', city: ..., country: .... }
    },
  status: 'OK',
  distance: '1234' # kilometers between first departure airport & last arrival airport
  error_message: nil
}

In case the flight is NOT found, the response of API is:
{
  route: nil,
  status: 'FAIL',
  distance: 0,
  error_message: description of what went wrong
}


File script.rb is a script, that takes the path and name of a CSV file and fills it with flight information.

## Setup

1. Clone this repo
2. Install ruby v3.0.0
3. Run bundle install

## Usage

To fill in a CSV file run script and provide the file path and name:
ruby script.rb

