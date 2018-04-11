require 'date'
require 'pry'
require_relative '../level4/action'
require_relative '../level5/option'

class Rental
  attr_reader :id, :start_date, :end_date, :distance
  attr_writer :car, :options

  def initialize(attributes = {})
    @id = attributes[:id]
    @start_date = convert_sting_to_date(attributes[:start_date])
    @end_date = convert_sting_to_date(attributes[:end_date])
    @distance = attributes[:distance]
    @car = attributes[:car]
    @options = []
  end

  def self.find_by_id(rentals, rental_id)
    rentals.each do |rental|
      if rental.id == rental_id
        return rental
      end
    end
  end

  def duration
    @end_date && @start_date ? (@end_date - @start_date + 1).to_i : 0
  end

  def price_time
    (duration * @car.price_per_day).to_i
  end

  def price_time_level_2
    1.upto(duration).sum do |day|
      case day
      when 1
        @car.price_per_day
      when 2..4
        @car.price_per_day - (@car.price_per_day * 0.1)
      when 5..10
        @car.price_per_day - (@car.price_per_day * 0.3)
      else
        @car.price_per_day - (@car.price_per_day * 0.5)
      end
    end
  end

  def price_distance
    (@distance * @car.price_per_km).to_i
  end

  def compute_price(level)
    case level
    when 'level1'
      (price_time + price_distance).to_i
    when 'level2'
      (price_time_level_2.to_i + price_distance).to_i
    else
      0
    end
  end

  def convert_sting_to_date(string)
    begin
      Date.parse(string).to_date
    rescue
      nil
    end
  end

  ##### Level 4 and 5 #####
  def actions
    @actions = []
    price = compute_price('level2')
    commission = (price * 0.3).to_i
    insurance_fee = (commission / 2).to_i
    assistance_fee = duration * 100
    owner_fee = price - (price * 0.3).to_i
    drivy_fee = commission - insurance_fee - assistance_fee
    @options.each do |option|
      case option.type
        when 'gps'
          price += option_price_per_day('gps') * duration * 100
          owner_fee += option_price_per_day('gps') * duration * 100
        when 'baby_seat'
          price += option_price_per_day('baby_seat') * duration * 100
          owner_fee += option_price_per_day('baby_seat') * duration * 100
        when 'additional_insurance'
          price += option_price_per_day('additional_insurance') * duration * 100
          drivy_fee += option_price_per_day('additional_insurance') * duration * 100
      end
    end
    if price != 0
      @actions << Action.new(who: 'driver', type: 'debit', amount: price)
      @actions << Action.new(who: 'owner', type: 'credit', amount: owner_fee)
      @actions << Action.new(who: 'insurance', type: 'credit', amount: insurance_fee)
      @actions << Action.new(who: 'assistance', type: 'credit', amount: assistance_fee)
      @actions << Action.new(who: 'drivy', type: 'credit', amount: drivy_fee)
    end
    @actions.collect { |action| action.convert_to_hash }
  end

  def add_option(option)
    @options << option
  end

  def options
    @options.map do |option|
      option.type
    end
  end

  def option_price_per_day(option_type)
    case option_type
    when 'gps'
      return 5
    when 'baby_seat'
      return 2
    when 'additional_insurance'
      return 10
    else
      return 0
    end
  end
end


