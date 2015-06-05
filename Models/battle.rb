# battle between player and mob
class Battle
  attr_accessor :id, :state, :player, :mob, :player_loc, :mob_loc

  #
  ## CLASS METHODS
  #

  def initialize(player, mob, player_loc, mob_loc)
    @id     = object_id
    @state  = 0
    @player = player
    @mob    = mob
    @player_loc = player_loc
    @mob_loc = mob_loc
  end

  def ask_user_battle_input
  	puts "Mob Name: #{mob.name}"
    puts "Health: #{mob.health}/#{mob.max_health}"
    puts "Damage: #{mob.damage}"
    puts "\nYour stats:"
    puts "Health: #{player.health}/#{player.max_health}"
    puts "Damage: #{player.damage}"
    puts "\nWhat are you going to do? (#{'Attack'.colorize(93)}, #{'Bag'.colorize(93)}, #{'Run'.colorize(93)})"
    print '-->'

    user_battle_input = gets.chomp.upcase
    user_battle_input
  end

  def initiate_attack
  	self.mob.health -= player.damage
    puts "You hit #{mob.name} for #{player.damage}!".colorize(93)

 	if mob.health <= 0 && player.health > 0
      # Player kills mob 	
      mob.map.current_map[mob_loc[0]][mob_loc[1]]       = 'P'
      mob.map.current_map[player_loc[0]][player_loc[1]] = '.'

      player.update_exp(mob.level)
      puts "you killed it, gained #{mob.level} exp.".colorize(92)
      self.state = 1

    else
      mob_attack
    end
  end

  def mob_attack
  	player.health -= mob.damage
    puts "#{mob.name} hits you for #{mob.damage}!".colorize(93)

    if player.health <= 0 && mob.health > 0
      # Mob kills player
      puts 'you died'.colorize(91)
      self.state = 1
      player.health = 0
      find_new_player_loc('c', player_loc, current_map)
    end
  end

  def attempt_run
  	if [*1..100].sample > 25
      puts 'Got away!'.colorize(92)

  	  self.state = 1
  	else
  	  puts 'Couldn\'t escape!'.colorize(91)

  	  mob_attack
    end
  end

end