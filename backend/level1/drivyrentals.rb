require 'json'
require 'pry'
require_relative 'car'
require_relative 'rental'
require_relative '../level4/action'

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

  def rental_list_with_price(rentals, level)
    @rentals_with_price = rentals.collect { |rental| { 'id' => rental.id, 'price' => rental.compute_price(level) } }
  end

  ##### for Level 3 #####
  def rental_list_with_commission(rentals)
    @rental_with_commission = rentals.collect { |rental|
      {
        'id' => rental.id,
        'price' => rental.compute_price('level2'),
        'commission' => {
          'insurance_fee' => rental.insurance_fee,
          'assistance_fee' => rental.assistance_fee,
          'drivy_fee' => rental.commission - rental.insurance_fee - rental.assistance_fee
        }
      }
    }
  end

  ##### for Level 4 #####
  def rental_list_with_actions(rentals)
    @rental_with_actions = rentals.collect { |rental|
      {
        'id' => rental.id,
        'actions' => rental.actions
      }
    }
  end

  ### for Level 5 #####
  def options_hydration(rentals)
    rb_hash = parse_json
    @options = []
    rb_hash['options'].each do |item|
      @options << Option.new(
        id: item['id'],
        rental: Rental.find_by_id(rentals, item['rental_id']),
        type: item['type'])
    end
    return @options
  end

  def add_options_to_rentals(options, rentals)
    @rentals_with_options = []
    options.each do |option|
      rental_found = Rental.find_by_id(rentals, option.rental.id)
      rentals.each do |rental|
        rental.add_option(option) if rental == rental_found
        @rentals_with_options << rental
      end
    end
    return @rentals_with_options
  end

  def rental_list_with_options(rentals)
    @rental_with_options = rentals.collect { |rental|
      {
        'id' => rental.id,
        'options' => rental.options,
        'actions' => rental.actions
      }
    }
  end

  def rentals_serialization_to_json(level)
    File.open(@output_file, 'w') do |f|
      case level
      when 'level1'
        f.write(JSON.pretty_generate(rentals: @rentals_with_price))
      when 'level2'
        f.write(JSON.pretty_generate(rentals: @rentals_with_price))
      when 'level3'
        f.write(JSON.pretty_generate(rentals: @rental_with_commission))
      when 'level4'
        f.write(JSON.pretty_generate(rentals: @rental_with_actions))
      when 'level5'
        f.write(JSON.pretty_generate(rentals: @rental_with_options))
      else
        f.write(JSON.pretty_generate('Error'))
      end
    end
  end
end
