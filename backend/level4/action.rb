class Action
  attr_reader :who, :type, :amount

  def initialize(attributes = {})
    @who = attributes[:who]
    @type = attributes[:type]
    @amount = attributes[:amount]
  end

  def convert_to_hash
    {
      who: @who,
      type: @type,
      amount: @amount
    }
  end
end
