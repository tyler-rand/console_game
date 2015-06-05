# Item -- any armor, weapon, etc
class Item
  attr_accessor :id, :ilvl, :name, :type, :quality, :attributes

  #
  ## CLASS METHODS
  #

  def self.roll_new(ilvl)
    q    = { 'Shitty' => 0.2, 'Normal' => 0.5, 'Magic' => 0.3, 'Rare' => 0.1, 'Unique' => 0.05, 'Legendary' => 0.01 }
    qcc  = 0
    q.each { |e, w| q[e] = qcc += w }

    r        = rand(0..qcc)
    selected = q.find { |_, w| w > r }

    quality  = selected[0]
    name     = %w(Occulus Buriza Windforce Enigma HOTO Gore).sample
    type     = %w(weapon chest helm boots gloves pants).sample

    if type == 'weapon'
      dmg        = ((((50 + ilvl) * 2) - 90) * (rand(0.85..1.15))).floor
      speed      = rand(0.8..1.4).round(1)

      Item.new(ilvl: ilvl, name: name, type: type, quality: quality, damage: dmg, speed: speed)

    else # any armor
      armor      = ((((100 + ilvl) * 2) - 40) * (rand(0.5..2))).floor

      Item.new(ilvl: ilvl, name: name, type: type, quality: quality, armor: armor)
    end
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
    File.open('ItemsDB.yml', 'a') { |f| f.write(to_yaml) }
  end
end
