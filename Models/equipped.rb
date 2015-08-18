# a player's equipped items
class Equipped
  attr_accessor :id, :player, :weapon, :chest, :pants, :helm, :gloves, :boots

  #
  ## INSTANCE METHODS
  #

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
    window.win.setpos(2, 2)
    window.win.addstr('-------------')
    window.win.setpos(3, 3)
    # !weapon.nil? ? window.win.addstr("Weapon: #{colorize_item_name(weapon)}, dmg: #{weapon.attributes[:damage]}, speed: #{weapon.attributes[:speed]}") : window.win.addstr('Weapon not equipped')
    # !chest.nil? ? window.win.addstr("Chest Armor: #{colorize_item_name(chest)}, armor: #{chest.attributes[:armor]}") : window.win.addstr('Chest not equipped')
    # !pants.nil? ? window.win.addstr("Pants: #{colorize_item_name(pants)}, armor: #{pants.attributes[:armor]}") : window.win.addstr('Pants not equipped')
    # !helm.nil? ? window.win.addstr("Helm: #{colorize_item_name(helm)}, armor: #{helm.attributes[:armor]}") : window.win.addstr('Helm not equipped')
    # !gloves.nil? ? window.win.addstr("Gloves: #{colorize_item_name(gloves)}, armor: #{gloves.attributes[:armor]}") : window.win.addstr('Gloves not equipped')
    # !boots.nil? ? window.win.addstr("Boots: #{colorize_item_name(boots)}, armor: #{boots.attributes[:armor]}") : window.win.addstr('Boots not equipped')
    # window.win.addstr('--------------')
    window.win.refresh
  end
end
