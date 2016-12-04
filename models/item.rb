# Item -- any armor, weapon, etc
class Item
  attr_accessor :id, :ilvl, :name, :type, :quality, :value, :attributes

  TYPES        = %w(weapon chest helm boots gloves pants).freeze
  WEAPON_TYPES = %w(axe mace sword dagger).freeze
  CHEST_TYPES  = %w(chainmail leather cloth plate).freeze
  HELM_TYPES   = %w(cap mask horns visor).freeze
  BOOT_TYPES   = %w(boots heavy\ boots plate\ boots treads).freeze
  GLOVE_TYPES  = %w(gloves heavy\ gloves mitts plate\ gloves).freeze
  PANT_TYPES   = %w(cloth leather platemail chainmail).freeze

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
    type    = TYPES.sample
    name    = random_name(type)
    value   = ilvl * 100
    args    = {ilvl: ilvl, name: name, type: type, quality: quality, value: value}

    if type == 'weapon'
      WeaponItem.new(args, damage: nil, speed: nil)
    else # any armor
      ArmorItem.new(args, defense: nil)
    end
  end

  # private class methods

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
    when 'weapon' then WEAPON_TYPES.sample
    when 'chest'  then CHEST_TYPES.sample
    when 'helm'   then HELM_TYPES.sample
    when 'boots'  then BOOT_TYPES.sample
    when 'gloves' then GLOVE_TYPES.sample
    when 'pants'  then PANT_TYPES.sample
    end
  end

  private_class_method :random_quality, :random_name
end
