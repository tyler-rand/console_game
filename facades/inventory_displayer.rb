# prints inventory list to the window
class InventoryDisplayer
  def initialize(inventory:, window:)
    @inventory = inventory
    @win = window.win
  end

  def list
    @win.setpos(2, 2)
    @win.addstr("------ #{@inventory.player.name.upcase}\'S BAG -------")
    @win.setpos(3, 2)

    display_all_items
  end

  private

  def display_all_items
    @inventory.items.each do |item, i|
      print_item_attr(item, i)
      @win.setpos(@win.cury + 1, 2)
    end
  end

  def print_item_attr(item, i)
    if item.type == 'weapon'
      @win.addstr("[#{i}] #{item.name}, dmg: #{item.damage},"\
                        " speed: #{item.speed}")
    else
      @win.addstr("[#{i}] #{item.name}, defense: #{item.defense}")
    end
  end
end
