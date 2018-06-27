# tracks player stats and skills
class Player
  attr_reader :name, :password, :species, :type, :quest_log
  attr_accessor :level, :current_exp, :max_exp, :health, :max_health, :defense, :damage,
                :crit_chance, :listeners, :equipped, :inventory, :location, :energy,
                :max_energy, :strength, :agility, :intelligence, :unused_skills

  MAP_ICON = 'P'.freeze

  def initialize(name:, password:, species:, type:)
    @id       = object_id
    @name     = name
    @password = password
    @species  = species
    @type     = type

    init_experience_and_level
    init_resources
    init_stats
    init_damage_and_armor

    @location  = []
    @listeners = []
    @equipped  = Equipped.new(player: self)
    @inventory = Inventory.new(player: self)
    @quest_log = QuestLog.new(player: self)
  end

  def self.load(input_name, input_pass)
    # try to match input name
    player = open_all.reverse.find { |p| p.name == input_name }
    # then try to match password
    verify_credentials(player, input_pass)
  end

  # private class methods

  def self.open_all
    YAML.load_stream(open('db/PlayersDB.yml'))
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

  private_class_method :open_all, :verify_credentials

  def save
    File.open('db/PlayersDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def update_stats
    @defense = equipped.calc_defense
    @damage = equipped.calc_damage + base_damage
    save
  end

  def add_exp(exp)
    @current_exp += exp
    level_up if current_exp >= max_exp
  end

  def add_quest_rewards(quest)
    InventoryInteractor.new(self, nil, nil).add_item(quest.item_reward) if quest.item_reward
    inventory.money += quest.cash_reward
    add_exp(quest.xp_reward)
  end

  private

  def init_experience_and_level
    @level         = 1
    @current_exp   = 0
    @max_exp       = 10
    @unused_skills = 1
  end

  def init_resources
    @health     = 100
    @max_health = 100
    @energy     = 100
    @max_energy = 100
  end

  def init_stats
    @strength     = 1
    @agility      = 1
    @intelligence = 1
  end

  def init_damage_and_armor
    @defense     = 0
    @damage      = base_damage
    @crit_chance = 0
  end

  def base_damage
    5 + @strength
  end

  def level_up
    @level += 1
    @unused_skills += 1
    @current_exp = current_exp - max_exp
    increase_stats_after_lvl_up
    update_max_exp_after_lvl_up
    update_stats
    display_level_up_msg
  end

  def increase_stats_after_lvl_up
    @strength += 1
    @agility += 1
    @intelligence += 1
    @health += level
    @max_health += level
  end

  def update_max_exp_after_lvl_up
    @max_exp = level_exp[level]
  end

  def display_level_up_msg
    msgs = [
      Message.new("> You've leveled up! Now level #{level}.", 'green'),
      Message.new('> Strength, Agility, Intelligence, and Health all increased.', 'green')
    ]
    $message_win.display_messages(msgs)
  end

  def level_exp
    { 1 => 10, 2 => 20, 3 => 30, 4 => 40, 5 => 50 }
  end
end
