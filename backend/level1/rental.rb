require 'date'

class Rental
  attr_reader :id, :start_date, :end_date, :distance
  attr_writer :car

  def initialize(attributes = {})
    @id = attributes[:id]
    @start_date = convert_sting_to_date(attributes[:start_date])
    @end_date = convert_sting_to_date(attributes[:end_date])
    @distance = attributes[:distance]
    @car = attributes[:car]
  end

  def duration
    @end_date && @start_date ? (@end_date - @start_date + 1).to_i : 0
  end

  def price_time
    (duration * @car.price_per_day).to_i
  end

  def price_time_level_2
    (1.upto(duration)).sum do |day|
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
end
