# battle between player and mob
class Battle
  attr_accessor :id, :state, :player, :mob, :map

  #
  ## CLASS METHODS
  #

  def initialize(player, mob, map)
    @id     = object_id
    @state  = 0
    @player = player
    @mob    = mob
    @map    = map
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
    messages = [["> You hit #{mob.name} for #{player.damage}!", 'green']]

    # Player kills mob
    if mob.health <= 0 && player.health > 0
      map.current_map[mob.location[0]][mob.location[1]]       = 'P'
      map.current_map[player.location[0]][player.location[1]] = '.'

      player.set_location(map.current_map)
      player.update_exp(mob.level)

      messages << ["> You killed it! Gained #{mob.level} exp.", 'green']
      self.state = 1

    # Mob attacks back
    else
      mob_attack.each { |result_msg| messages << result_msg }
    end

    $game.message_log.add_msgs(messages)
    $messages_win.display_messages($game.message_log)
  end

  def mob_attack
  	player.health -= mob.damage
    messages = [["> #{mob.name} hits you for #{mob.damage}!", 'red'], ['> ATTACK | BAG | RUN', 'yellow']]

    # Mob kills player
    if player.health <= 0 && mob.health > 0
      messages << ['> You died.', 'red']
      self.state = 1
      player.health = 0
      # player.find_new_loc('c', current_map)
    else
      messages << ['--> ', 'normal']
    end

    messages
  end

  def attempt_run
  	if [*1..100].sample > 25
      messages = [['> Got away!', 'green']]

  	  self.state = 1
  	else
      messages = [['> Couldn\'t escape!', 'red']]
      mob_attack.each { |result_msg| messages << result_msg }
    end

    $game.message_log.add_msgs(messages)
    $messages_win.display_messages($game.message_log)
  end

end