# tracks player stats and skills
class Player
  attr_accessor :id, :name, :species, :type, :password, :level, :current_exp, :max_exp,
   :health, :max_health, :armor, :damage, :crit_chance, :equipped, :inventory

  #
  ## CLASS METHODS
  #

  # this method probly belongs in a helper
  def self.species_info
    puts ' -------------'
    puts ' --- HERO SPECIES ---'
    puts ' -------------'
    puts 'Human:'
    puts 'Alien:'
    puts 'Ogre:'
    puts 'Robot:'
    puts 'Ghost:'
  end

  # this method probly belongs in a helper
  def self.type_info
    puts ' -------------'
    puts ' -- HERO CLASSES --'
    puts ' -------------'
    puts 'Warrior: Melee hero who is master of all weapons'
    puts 'Assassin: Melee hero who excels in the shadows'
    puts 'Sniper: Ranged hero with big damage and low health'
    puts 'Summoner: Spellcasting hero who can summon minions'
  end

  def self.load_by_credentials(input_name, input_pass)
    players       = YAML.load_stream(open('PlayersDB.yml'))
    unauth_player = nil
    player        = nil
    message       = ''

    # first try to match input name
    players.map do |p|
      unauth_player = p if p.name == input_name
    end

    if unauth_player.nil?
      message = 'Name not found'.colorize(101)
    else # then try and match password
      if input_pass == unauth_player.password
        player  = unauth_player
        message  = 'Loaded player successfully.'.colorize(92)
      else
        message  = "Error: incorrect password. pw: #{input_pass}//#{unauth_player.password}".colorize(101)
      end
    end

    puts message
    player
  end

  def self.load_by_id(player_id)
    players = YAML.load_stream(open('PlayersDB.yml'))
    player  = nil
    
    players.map do |p|
      player = p if p.id == player_id
    end
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(name:, species:, type:, password:) # type = player class
    @id          = object_id
    @name        = name
    @password    = password

    @species     = species
    @type        = type

    @level       = 1
    @current_exp = 0
    @max_exp     = 10
    @health      = 100
    @max_health  = 100

    @armor       = 0
    @damage      = 5
    @crit_chance = 0

    @equipped    = Equipped.new(player: self) 
    @inventory   = Inventory.new(player: self)
  end

  def save
    File.open('PlayersDB.yml', 'a') { |f| f.write(to_yaml) }
    puts "SAVED!".colorize(92)
  end

  def update_stats # refresh stats after changing equipped items
  # NEEDS REFACTOR
    armor = 0
    armor += equipped.chest.attributes[:armor] unless equipped.chest.nil?
    armor += equipped.pants.attributes[:armor] unless equipped.pants.nil?
    armor += equipped.helm.attributes[:armor] unless equipped.helm.nil?
    armor += equipped.gloves.attributes[:armor] unless equipped.gloves.nil?
    armor += equipped.boots.attributes[:armor] unless equipped.boots.nil?
    self.armor = armor
    self.damage = (equipped.weapon.attributes[:damage] * equipped.weapon.attributes[:speed]).round(1) unless equipped.weapon.nil?
    puts "armor:#{self.armor}, dmg:#{self.damage}"
    self.save
  end

  def update_exp(exp) # add to exp after a mob kill or quest completion
    self.current_exp += exp

    if current_exp >= max_exp
      self.level      += 1
      self.current_exp = current_exp - max_exp
      max_exp     = levels_exp(level)

      puts "LEVEL UP! You're now level #{self.level}"
      save
    end
  end

  def engage_mob(map, player_loc, new_player_loc) # REFACTOR
    mob = map.mobs[new_player_loc]
    puts 'A MOB APPEARS! KILL IT!'
    puts '----'

    battle = Battle.new(self, mob, player_loc, new_player_loc)
  
    while battle.state == 0
      user_input = battle.ask_user_battle_input

      case user_input
      when 'ATTACK'
        battle.initiate_attack
      when 'BAG'
      when 'RUN'
        battle.attempt_run
      else
        puts 'Command not recognized, try again'.colorize(101)
      end
    end
  end

  def show_stats
    puts ' -------------'
    puts " --- #{name.upcase}'S STATS ----"
    puts ' -------------'
    puts "Level #{level} #{species} #{type}"
    puts "XP: #{current_exp}/#{max_exp}"
    puts "Cash: #{inventory.money}"
    puts "Health: #{health}/#{max_health}"
    puts "Damage: #{damage}"
    puts "Crit chance: #{crit_chance}%"
    puts "Armor: #{armor}"
    puts '--------------'
  end

  def show_skills
    puts ' -------------'
    puts " --- #{name.upcase}'S SKILLS ----"
    puts ' -------------'
  end
end
