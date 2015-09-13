# tracks player stats and skills
class Player
  attr_accessor :id, :name, :species, :type, :password, :level, :current_exp, :max_exp,
                :health, :max_health, :armor, :damage, :crit_chance, :equipped, :inventory, :location,
                :energy, :max_energy, :strength, :agility, :intelligence

  #
  ## CLASS METHODS
  #

  def self.open_all
    YAML.load_stream(open('db/PlayersDB.yml'))
  end

  def self.load(input_name, input_pass)
    # try to match input name
    player = Player.open_all.reverse.find { |p| p.name == input_name }
    # then try to match password
    Player.verify_credentials(player, input_pass)
  end

  def self.verify_credentials(player, input_pass)
    if player.nil?
      puts 'Name not found'.colorize(101)
    elsif input_pass == player.password
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
    self.armor = equipped.calc_armor
    self.damage = equipped.calc_damage
    save
  end

  def add_exp(exp)
    self.current_exp += exp
    level_up if current_exp >= max_exp
  end

  def level_up
    self.level += 1
    reset_current_exp_after_lvl_up
    reset_max_exp_after_lvl_up
  end

  private

  def reset_current_exp_after_lvl_up
    self.current_exp = current_exp - max_exp
  end

  def reset_max_exp_after_lvl_up
    self.max_exp = level_exp[level]
  end

  def level_exp
    { 1 => 10, 2 => 20, 3 => 30, 4 => 40, 5 => 50 }
  end
end
