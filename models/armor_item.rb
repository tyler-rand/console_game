require_relative 'item'

# armor subclass of item
class ArmorItem < Item
  attr_accessor :defense

  def initialize(args = {})
    super
    @defense = roll_defense
  end

  private

  def roll_defense
    ((((100 + ilvl) * 2) - 40) * (rand(0.5..2))).floor
  end
end
