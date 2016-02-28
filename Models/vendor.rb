# vendor sells/buys items
class Vendor
  attr_accessor :id, :name, :location, :level, :type, :inventory

  def self.roll_new(map, location)
    vendor = Vendor.new(level: map.level, location: location, type: 'item vendor')
    vendor.inventory.add_random_items(map.level, qty: 10)
    vendor
  end

  def self.map_character
    'N'
  end

  def initialize(level:, location:, type:)
    @id        = object_id
    @name      = vendor_name_list.sample
    @location  = location
    @level     = level
    @type      = type
    @inventory = Inventory.new(player:self)
  end

  private

  def vendor_name_list
    ['Bob', 'Flo']
  end
end
