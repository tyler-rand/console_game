# player's inventory, basicslly means player's items
class Inventory
  attr_accessor :id, :player, :items, :money

  #
  ## INSTANCE METHODS
  #

  def initialize(player:)
    @id     = object_id
    @player = player
    @items  = []
    @money  = 0
  end

  def list(window) # list items in inventory
    window.win.setpos(1, 2)
    window.win.addstr("------ #{player.name.upcase}\'S BAG -------")
    window.win.setpos(2, 2)
    window.win.addstr('-------------')
    items.map do |item, i|
      if item.type == 'weapon'
        window.win.setpos(i + 2, 2)
        window.win.addstr("[#{i}] #{item.name} #{item.type}. dmg: #{item.attributes[:damage]}, speed: #{item.attributes[:speed]}")
      else
        window.win.setpos(i + 2, 2)
        window.win.addstr("[#{i}] #{item.name} #{item.type}. armor: #{item.attributes[:armor]}")
      end
    end
    window.win.refresh
  end

  def add_money(money)
    self.money += money
  end

  def add_items(map_level)
    index = items.length

    20.times do
      index += 1
      item = Item.roll_new(map_level)
      items << [item, index]
    end
  end

  def find_item(item_num)
    items.each { |item, index| return item if index == item_num }
  end

  def refresh_indexes
    self.items = items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
  end
end
