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
    puts !weapon.nil? ? " Weapon: #{weapon.name}, dmg: #{weapon.attributes[:damage]}, speed: #{weapon.attributes[:speed]}" : 'Weapon not equipped'
    puts !chest.nil? ? " Chest Armor: #{chest.name}, armor: #{chest.attributes[:armor]}" : 'Chest not equipped'
    puts !pants.nil? ? " Pants: #{pants.name}, armor: #{pants.attributes[:armor]}" : 'Pants not equipped'
    puts !helm.nil? ? " Helm: #{helm.name}, armor: #{helm.attributes[:armor]}" : 'Helm not equipped'
    puts !gloves.nil? ? " Gloves: #{gloves.name}, armor: #{gloves.attributes[:armor]}" : 'Gloves not equipped'
    puts !boots.nil? ? " Boots: #{boots.name}, armor: #{boots.attributes[:armor]}" : 'Boots not equipped'
    puts '--------------'
  end

end