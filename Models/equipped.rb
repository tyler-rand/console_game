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
    !weapon.nil? ? window.win.addstr("Weapon: #{weapon.name}, dmg: #{weapon.attributes[:damage]}, speed: #{weapon.attributes[:speed]}") : window.win.addstr('Weapon not equipped')
    window.win.setpos(4, 3)
    !chest.nil? ? window.win.addstr("Chest Armor: #{chest.name}, armor: #{chest.attributes[:armor]}") : window.win.addstr('Chest not equipped')
    window.win.setpos(5, 3)
    !pants.nil? ? window.win.addstr("Pants: #{pants.name}, armor: #{pants.attributes[:armor]}") : window.win.addstr('Pants not equipped')
    window.win.setpos(6, 3)
    !helm.nil? ? window.win.addstr("Helm: #{helm.name}, armor: #{helm.attributes[:armor]}") : window.win.addstr('Helm not equipped')
    window.win.setpos(7, 3)
    !gloves.nil? ? window.win.addstr("Gloves: #{gloves.name}, armor: #{gloves.attributes[:armor]}") : window.win.addstr('Gloves not equipped')
    window.win.setpos(8, 3)
    !boots.nil? ? window.win.addstr("Boots: #{boots.name}, armor: #{boots.attributes[:armor]}") : window.win.addstr('Boots not equipped')
    window.win.setpos(9, 3)
    window.win.addstr('--------------')
    window.win.refresh
  end
end
