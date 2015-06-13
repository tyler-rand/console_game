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

  def list
    puts ' -------------'
    puts " --- #{player.name.upcase}'S EQUIPPED ITEMS ----"
    puts ' -------------'
    puts !weapon.nil? ? " Weapon: #{colorize_item_name(weapon)}, dmg: #{weapon.attributes[:damage]}, speed: #{weapon.attributes[:speed]}" : 'Weapon not equipped'
    puts !chest.nil? ? " Chest Armor: #{colorize_item_name(chest)}, armor: #{chest.attributes[:armor]}" : 'Chest not equipped'
    puts !pants.nil? ? " Pants: #{colorize_item_name(pants)}, armor: #{pants.attributes[:armor]}" : 'Pants not equipped'
    puts !helm.nil? ? " Helm: #{colorize_item_name(helm)}, armor: #{helm.attributes[:armor]}" : 'Helm not equipped'
    puts !gloves.nil? ? " Gloves: #{colorize_item_name(gloves)}, armor: #{gloves.attributes[:armor]}" : 'Gloves not equipped'
    puts !boots.nil? ? " Boots: #{colorize_item_name(boots)}, armor: #{boots.attributes[:armor]}" : 'Boots not equipped'
    puts '--------------'
  end
end