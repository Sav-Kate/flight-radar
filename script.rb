require "parallel"
require 'httparty'
require 'csv'
require 'uri'

def number_of_legs(route)
    return route.kind_of?(Array) ? route.size : 1
end

puts "Enter the path and file name"
file_path = gets.chomp
puts "Data is loading"

flight_rows = CSV.read(file_path, headers:true, skip_blanks: true)

pages_to_scrape = flight_rows.map do |flight_row|
    next unless flight_row["Example flight number"]
    flight_number = URI.encode(flight_row["Example flight number"].gsub(/\s/, ""))
    {
        "row" => flight_row,
        "Link" => "http://localhost:3000/flight_route/#{flight_number}"
    }
end

Parallel.map(pages_to_scrape, in_threads: 10) do |page_to_scrape| 
	response = HTTParty.get(page_to_scrape["Link"])
    flight_row = page_to_scrape["row"]

    if response["error_message"]
        flight_row["Flight number used for lookup"] = response["used_flight_number"]
        flight_row["Lookup status"] = response["status"]
        flight_row["Number of legs"] = 0
        flight_row["Distance in kilometers"] = response["distance"]
    else
        flight_row["Flight number used for lookup"] = response["used_flight_number"]
        flight_row["Lookup status"] = response["status"]
        flight_row["Number of legs"] = number_of_legs(response["route"])
        flight_row["First leg departure airport IATA"] = response["route"]["departure"]["iata"]
        flight_row["Last leg arrival airport IATA"] = response["route"]["arrival"]["iata"]
        flight_row["Distance in kilometers"] = response["distance"]
    end
end


headers = ["Example flight number","Flight number used for lookup", "Lookup status", "Number of legs", "First leg departure airport IATA",
    "Last leg arrival airport IATA", "Distance in kilometers"]

CSV.open(file_path, 'w', headers:true) do |csv| 
    csv << headers
    flight_rows.each do |row|
        csv << row
    end
end

puts "Data is loaded"