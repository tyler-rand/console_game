# tracks player stats and skills
class Player
  attr_accessor :id, :name, :species, :type, :password, :level, :current_exp, :max_exp,
                :health, :max_health, :armor, :damage, :crit_chance, :equipped, :inventory, :location,
                :energy, :max_energy, :strength, :agility, :intelligence

  #
  ## CLASS METHODS
  #

  def self.prompt_and_create
    name = Game.prompt_player_name
    species = Game.prompt_player_species
    player_type = Game.prompt_player_type
    password = Game.prompt_player_pass

    player = Player.new(name: name, species: species, type: player_type, password: password)

    player.save
    player
  end


  def self.load
    puts "\nEnter username:password (Ex: ghostpineapple:SA32es!sx)"
    print '-->'

    user_input = gets.chomp.split(':')
    input_name = user_input[0].capitalize
    input_pass = user_input[1]

    player = Player.verify_credentials(input_name, input_pass)
    player
  end

  def self.verify_credentials(input_name, input_pass)
    players = YAML.load_stream(open('PlayersDB.yml'))
    player  = nil
    message = ''

    # first try to match input name
    unauth_player = players.find { |p| p.name == input_name }

    if unauth_player.nil?
      message = 'Name not found'.colorize(101)
    # then try and match password
    else
      if input_pass == unauth_player.password
        player  = unauth_player
        message = 'Loaded player successfully.'.colorize(92)
      else
        message = "Error: incorrect password. pw: #{input_pass}//#{unauth_player.password}".colorize(101)
      end
    end

    puts message
    player
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
    File.open('PlayersDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def find_location(current_map)
    current_map.each do |line|
      self.location = [current_map.index(line), line.index('P')] if line.include?('P')
    end
  end

  # refresh stats after changing equipped items
  def update_stats # NEEDS REFACTOR
    armor = 0
    armor += equipped.chest.attributes[:armor] unless equipped.chest.nil?
    armor += equipped.pants.attributes[:armor] unless equipped.pants.nil?
    armor += equipped.helm.attributes[:armor] unless equipped.helm.nil?
    armor += equipped.gloves.attributes[:armor] unless equipped.gloves.nil?
    armor += equipped.boots.attributes[:armor] unless equipped.boots.nil?
    self.armor = armor
    self.damage = (equipped.weapon.attributes[:damage] * equipped.weapon.attributes[:speed]).round(1) unless equipped.weapon.nil?
    puts "armor:#{self.armor}, dmg:#{damage}"
    save
  end

  # add to exp after a mob kill or quest completion
  def update_exp(exp)
    self.current_exp += exp
    level_up if current_exp >= max_exp
  end

  def level_up
    self.level += 1
    reset_current_exp
    reset_max_exp
  end

  def reset_current_exp
    self.current_exp = current_exp - max_exp
  end

  def reset_max_exp
    self.max_exp = level_exp(level)
  end

  def engage_mob(map, new_player_loc)
    mob = nil
    map.mobs.each { |m| mob = m if m.location == new_player_loc }

    battle = Battle.new(self, mob, map)

    loop do
      break if battle.state == 1
      messages = []
      user_input = $message_win.win.getstr.upcase
      $message_log.append(user_input)

      case user_input
      when 'ATTACK'
        battle.initiate_attack.each { |result_msg| messages << result_msg }
      when 'BAG'
      when 'RUN'
        battle.attempt_run.each { |result_msg| messages << result_msg }
      else
        messages = [Message.new('> Command not recognized, try again', 'red'), Message.new('> ATTACK | BAG | RUN', 'yellow'), Message.new('--> ', 'normal')]
      end

      $message_log.show_msgs(messages)
    end
  end

  def show_skills
  end
end
