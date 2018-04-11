class Option
  attr_reader :type, :id
  attr_writer :rental

  def initialize(attributes = {})
    @id = attributes[:id]
    @type = attributes[:type]
    @rental = attributes[:rental]
  end

  def price_per_day
    if @type == 'gps'
      @price = 5
    elsif @type == 'baby_seat'
      @price = 2
    elsif @type == 'additional_insurance'
      @price = 10
    else
      @price = nil
    end
  end

  def total_price
    price_per_day * @rental.duration
  end

  def rental
    @rental
  end

  def type
    @type
  end
end
