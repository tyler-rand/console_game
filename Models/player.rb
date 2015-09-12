# tracks player stats and skills
class Player
  attr_accessor :id, :name, :species, :type, :password, :level, :current_exp, :max_exp,
                :health, :max_health, :armor, :damage, :crit_chance, :equipped, :inventory, :location,
                :energy, :max_energy, :strength, :agility, :intelligence

  #
  ## CLASS METHODS
  #

  def self.verify_credentials(input_name, input_pass)
    players = YAML.load_stream(open('db/PlayersDB.yml'))

    # try to match input name
    player = players.reverse.find { |p| p.name == input_name }

    return puts 'Name not found'.colorize(101) if player.nil?

    # then try and match password
    if input_pass == player.password
      puts 'Loaded player successfully.'.colorize(92)
      player
    else
      puts "Error: incorrect password. input: #{input_pass}, pass: #{player.password}".colorize(101)
    end
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(options = {}) # type = players in-game class
    @id       = object_id
    @name     = options[:name]
    @password = options[:password]

    @species = options[:species]
    @type    = options[:type]

    @level       = 1
    @current_exp = 0
    @max_exp     = 10

    @health      = 100
    @max_health  = 100
    @energy      = 100
    @max_energy  = 100

    @strength     = 1
    @agility      = 1
    @intelligence = 1

    @armor       = 0
    @damage      = 5
    @crit_chance = 0

    @location  = []
    @equipped  = Equipped.new(player: self)
    @inventory = Inventory.new(player: self)
  end

  def save
    File.open('db/PlayersDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def find_location(current_map)
    current_map.each do |line|
      self.location = [current_map.index(line), line.index('P')] if line.include?('P')
    end
  end

  def update_stats
    calc_armor
    calc_damage
    save
  end

  def add_exp(exp)
    self.current_exp += exp
    level_up if current_exp >= max_exp
  end

  def level_up
    self.level += 1
    reset_current_exp
    reset_max_exp
  end

  private

  def calc_armor
    armor = 0
    armor += equipped.chest.armor unless equipped.chest.nil?
    armor += equipped.pants.armor unless equipped.pants.nil?
    armor += equipped.helm.armor unless equipped.helm.nil?
    armor += equipped.gloves.armor unless equipped.gloves.nil?
    armor += equipped.boots.armor unless equipped.boots.nil?
    self.armor = armor
  end

  def calc_damage
    self.damage = (equipped.weapon.damage * equipped.weapon.speed).round(1) unless equipped.weapon.nil?
  end

  def reset_current_exp
    self.current_exp = current_exp - max_exp
  end

  def reset_max_exp
    self.max_exp = level_exp[level]
  end

  def level_exp
    { 1 => 10, 2 => 20, 3 => 30, 4 => 40, 5 => 50 }
  end
end
