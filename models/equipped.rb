# a player's equipped items
class Equipped
  attr_accessor :player, :weapon, :chest, :pants, :helm, :gloves, :boots

  def initialize(player:)
    @id     = object_id
    @player = player

    @weapon = nil
    @chest  = nil
    @pants  = nil
    @helm   = nil
    @gloves = nil
    @boots  = nil
  end

  def list(window)
    window.win.setpos(1, 2)
    window.win.addstr("---- #{player.name.upcase}\'S EQUIPPED ITEMS ----")
    window.win.setpos(3, 3)

    display_equipped(window.win)

    window.win.refresh
  end

  def calc_damage
    weapon ? (weapon.damage * weapon.speed).round(1) : 0
  end

  def calc_defense
    armors.inject(:+)
  end

  private

  def display_equipped(win)
    %w(weapon chest pants helm gloves boots).each do |item|
      display_item(item, win)
      win.setpos(win.cury + 1, 3)
    end
  end

  def display_item(item, win)
    item_slot = send(item)

    return win.addstr("#{item.capitalize} not equipped.") if item_slot.nil?
    print_item_attr(item_slot, win)
  end

  def print_item_attr(item, win)
    if item != weapon
      win.addstr("#{item.type.capitalize}: #{item.name}, defense: #{item.defense}")
    else
      win.addstr("Weapon: #{item.name}, dmg: #{item.damage}, speed: #{item.speed}")
    end
  end

  def armors
    [
      chest ? chest.defense : 0,
      pants ? pants.defense : 0,
      helm ? helm.defense : 0,
      gloves ? gloves.defense : 0,
      boots ? boots.defense : 0
    ]
  end
end
