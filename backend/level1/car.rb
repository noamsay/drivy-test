class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(attributes = {})
    @id = attributes[:id]
    @price_per_day = attributes[:price_per_day]
    @price_per_km = attributes[:price_per_km]
  end

  def self.find_by_id(cars, car_id)
    cars.each do |car|
      if car.id == car_id
        return car
      end
    end
  end
end
