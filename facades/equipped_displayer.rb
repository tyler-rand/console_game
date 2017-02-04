# displays equipped items to the window
class EquippedDisplayer
  def initialize(equipped:, window:)
    @equipped = equipped
    @win = window.win
  end

  def list
    @win.setpos(1, 2)
    @win.addstr("---- #{@equipped.player.name.upcase}\'S EQUIPPED ITEMS ----")
    @win.setpos(3, 3)

    display_all_equipped

    @win.refresh
  end

  private

  def display_all_equipped
    %w(weapon chest pants helm gloves boots).each do |item_slot|
      item = @equipped.send(item_slot)

      display_item(item: item, item_slot: item_slot)
      @win.setpos(@win.cury + 1, 3)
    end
  end

  def display_item(item:, item_slot:)
    if item.nil?
      @win.addstr("#{item_slot.capitalize} not equipped.")
    else
      print_item_attributes(item)
    end
  end

  def print_item_attributes(item)
    if item == @equipped.weapon
      @win.addstr("Weapon: #{item.name}, dmg: #{item.damage}, speed: #{item.speed}")
    else
      @win.addstr("#{item.type.capitalize}: #{item.name}, defense: #{item.defense}")
    end
  end
end
