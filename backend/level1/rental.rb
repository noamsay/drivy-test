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

  def price_distance
    (@distance * @car.price_per_km).to_i
  end

  def price
    (price_time + price_distance).to_i
  end

  def convert_sting_to_date(string)
    begin
      Date.parse(string).to_date
    rescue
      nil
    end
  end
end
