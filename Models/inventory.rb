# player's inventory, holds all of a player's items and money
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
    window.win.setpos(2, 2)
    window.win.addstr("------ #{player.name.upcase}\'S BAG -------")
    window.win.setpos(3, 2)

    display_bag(window.win)
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
  end

  def refresh_indexes
    self.items = items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
  end

  private

  def display_bag(win)
    items.each do |item, i|
      print_item_attr(item, i, win)
      win.setpos(win.cury + 1, 2)
    end
  end

  def print_item_attr(item, i, win)
    if item.type == 'weapon'
      win.addstr("[#{i}] #{item.name}, dmg: #{item.damage},"\
                        " speed: #{item.speed}")
    else
      win.addstr("[#{i}] #{item.name}, defense: #{item.defense}")
    end
  end
end
