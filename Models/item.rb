# Item -- any armor, weapon, etc
class Item
  attr_accessor :id, :ilvl, :name, :type, :quality, :attributes

  #
  ## CLASS METHODS
  #

  def self.roll_new(ilvl)
    quality  = randomize_quality
    name     = %w(Occulus Buriza Windforce Enigma HOTO Gore).sample
    type     = %w(weapon chest helm boots gloves pants).sample

    if type == 'weapon'
      WeaponItem.new(ilvl: ilvl, name: name, type: type, quality: quality)
    else # any armor
      ArmorItem.new(ilvl: ilvl, name: name, type: type, quality: quality)
    end
  end

  def self.randomize_quality
    qualities = { 'Shitty' => 0.2, 'Normal' => 0.5, 'Magic' => 0.3, 'Rare' => 0.1,
                  'Unique' => 0.05, 'Legendary' => 0.01 }
    weight_total = 0
    qualities.each { |qual, weight| qualities[qual] = weight_total += weight }

    rand_weight = rand(0..weight_total)
    selected    = qualities.find { |_, weight| weight > rand_weight }
    selected[0]
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(ilvl:, name:, type:, quality:, **attributes)
    @id         = object_id
    @ilvl       = ilvl.to_i
    @name       = name
    @type       = type
    @quality    = quality
    @attributes = attributes
  end

  def save
    File.open('db/ItemsDB.yml', 'a') { |f| f.write(to_yaml) }
  end
end
