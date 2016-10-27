# vendor sells/buys items
class Vendor
  attr_accessor :id, :name, :location, :level, :type, :inventory

  MAP_ICON = 'N'
  INPUT_ERR_MSGS = ['> I didn\'t get that', '> What\'s that?', '> You\'re making no sense!']
  EXIT_MSGS = ['> Maybe next time!', '> See ya later!', '> Have a good one!', '> Take it easy!']
  VENDOR_NAME_LIST = %w(Bob Flo)

  def initialize(level:, location:, type:)
    @id        = object_id
    @name      = VENDOR_NAME_LIST.sample
    @location  = location
    @level     = level
    @type      = type
    @inventory = Inventory.new(player: self)
  end

  def self.roll_new(map, location)
    vendor = Vendor.new(level: map.level, location: location, type: 'item vendor')
    vendor.inventory.add_random_items(map.level, qty: 10)
    vendor
  end
end
