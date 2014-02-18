require 'addressable/uri'
require 'rest-client'
require 'nokogiri'
require 'json'
require './keys'


class DirectionFinder
  include Keys

  def run
    set_start
    parse_starting_location

    set_destination
    parse_ending_location

    output_directions
  end


  private

  def set_start
    puts "Enter your location"
    @start = gets.chomp
  end

  def set_destination
    puts "where would you like to go?"
    @destination = gets.chomp
  end

  def parse_starting_location
    location = Addressable::URI.new({
      scheme: "http",
      host: "maps.googleapis.com",
      path: "/maps/api/geocode/json",
      query_values: {
        address: @start,
        sensor: false
      }
    }).to_s

    raw_origin = JSON.parse(RestClient.get(location))
    lat_long = raw_origin['results'][0]['geometry']['location']

    @start = "#{lat_long['lat']},#{lat_long['lng']}"
  end

  def parse_ending_location
    location = Addressable::URI.new({
      scheme: "https",
      host: "maps.googleapis.com",
      path: "/maps/api/place/nearbysearch/json",
      query_values: {
        location: @start,
        rankby: "distance",
        sensor: false,
        key: GOOGLE_PUBLIC_API_KEY,
        keyword: @destination
      }
    }).to_s

    raw_destinations = JSON.parse(RestClient.get(location))
    @destination = raw_destinations["results"][0]["vicinity"]
  end

  def output_directions
    directions = Addressable::URI.new({
      scheme: "https",
      host: "maps.googleapis.com",
      path: "/maps/api/directions/json",
      query_values: {
        origin: @start,
        destination: @destination,
        sensor: false
      }
    }).to_s

    raw_results = JSON.parse(RestClient.get(directions))
    direction_steps = raw_results["routes"].first["legs"].first["steps"]

    puts
    direction_steps.each do |step|
      direction_step = Nokogiri::HTML(step["html_instructions"]).text
      puts direction_step.gsub("Destination ", "\nDestination ")
    end
  end
end

d = DirectionFinder.new
d.run