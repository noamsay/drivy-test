require 'json'
require_relative 'car'
require_relative 'rental'

class DrivyRentals
  attr_reader :input_file, :output_file

  def initialize(attributes = {})
    @input_file = attributes[:input_file]
    @output_file = attributes[:output_file]
  end

  def parse_json
    serialized = File.read(@input_file)
    JSON.parse(serialized)
  end

  def cars_hydration
    rb_hash = parse_json
    car_collection = []
    rb_hash['cars'].each do |item|
      car_collection << Car.new(
        id: item['id'],
        price_per_day: item['price_per_day'],
        price_per_km: item['price_per_km'])
    end
    @cars = car_collection
  end

  def rentals_hydration(cars_collection)
    rb_hash = parse_json
    rental_collection = []
    rb_hash['rentals'].each do |item|
      rental_collection << Rental.new(
        id: item['id'],
        car: Car.find_by_id(cars_collection, item['car_id']),
        start_date: item['start_date'],
        end_date: item['end_date'],
        distance: item['distance'])
    end
    @rentals = rental_collection
  end

  def rental_list_with_price(rentals)
    @rentals_with_price = rentals.collect { |rental| { 'id' => rental.id, 'price' => rental.price } }
  end

  def rentals_serialization_to_json
    File.open(@output_file, 'w') do |f|
      f.write(JSON.pretty_generate(rentals: @rentals_with_price))
    end
  end
end
