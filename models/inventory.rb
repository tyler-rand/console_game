# player's inventory, holds all of a player's items and money
class Inventory
  attr_accessor :player, :items, :money

  def initialize(player:)
    @id     = object_id
    @player = player
    @items  = []
    @money  = 0
  end

  def display(window)
    InventoryDisplayer.new(inventory: self, window: window).list
  end

  def add_money(money)
    self.money += money
  end

  def add_random_items(map_level, qty:)
    index = items.length

    qty.times do
      index += 1
      item = Item.roll_new(map_level)
      items << [item, index]
    end
  end

  def find_item(item_num)
    items.each { |item, index| return item if index == item_num }
    nil
  end

  def refresh_indexes
    self.items = items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
  end
end
