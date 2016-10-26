# Item -- any armor, weapon, etc
class Item
  attr_accessor :id, :ilvl, :name, :type, :quality, :value, :attributes

  def initialize(ilvl:, name:, type:, quality:, value:, **attributes)
    @id         = object_id
    @ilvl       = ilvl.to_i
    @name       = name
    @type       = type
    @quality    = quality
    @value      = value
    @attributes = attributes
  end

  def self.roll_new(ilvl)
    quality = random_quality
    type    = %w(weapon chest helm boots gloves pants).sample
    name    = random_name(type)
    value   = ilvl * 100

    if type == 'weapon'
      WeaponItem.new(ilvl: ilvl, name: name, type: type, quality: quality, value: value)
    else # any armor
      ArmorItem.new(ilvl: ilvl, name: name, type: type, quality: quality, value: value)
    end
  end

  def self.random_quality
    qualities = { 'Shitty' => 0.2, 'Normal' => 0.5, 'Magic' => 0.3, 'Rare' => 0.1,
                  'Unique' => 0.05, 'Legendary' => 0.01 }
    weight_total = 0
    qualities.each { |qual, weight| qualities[qual] = weight_total += weight }

    rand_weight = rand(0..weight_total)

    qualities.find { |_, weight| weight > rand_weight }
  end

  def self.random_name(type)
    case type
    when 'weapon'
      %w(axe mace sword dagger).sample
    when 'chest'
      %w(chainmail leather cloth plate).sample
    when 'helm'
      %w(cap mask horns visor).sample
    when 'boots'
      %w(boots heavy\ boots plate\ boots treads).sample
    when 'gloves'
      %w(gloves heavy\ gloves mitts plate\ gloves).sample
    when 'pants'
      %w(cloth leather platemail chainmail).sample
    end
  end
end
