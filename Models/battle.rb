# battle between player and mob
class Battle
  attr_accessor :id, :state, :map_movement, :map, :player, :location, :mob

  #
  ## CLASS METHODS
  #

  def initialize(map_movement)
    @id           = object_id
    @state        = 0 # 0 is ongoing battle, 1 is battle ended
    @map_movement = map_movement
    @map          = map_movement.map
    @player       = map_movement.player
    @location     = map_movement.new_player_loc
    @mob          = find_mob
  end

  def engage
    loop do
      break if state == 1
      user_input = $message_win.win.getstr.upcase
      $message_log.append(user_input)

      case user_input
      when 'ATTACK'
        messages = initiate_attack
      when 'BAG'
      when 'RUN'
        messages = attempt_run
      else
        messages = [Message.new('> Command not recognized, try again', 'red'),
                    Message.new('> ATTACK | BAG | RUN', 'yellow'), Message.new('--> ', 'normal')]
      end

      $message_log.show_msgs(messages)
    end
  end

  private

  def find_mob
    map.mobs.find { |m| m.location == location }
  end

  def initiate_attack
    mob.health -= player.damage
    messages = [Message.new("> You hit #{mob.name} for #{player.damage}!", 'green')]

    # Player kills mob
    if mob.health <= 0 && player.health > 0
      killed_mob.each { |result_msg| messages << result_msg }
    # Mob attacks back
    else
      mob_attack.each { |result_msg| messages << result_msg }
    end

    messages
  end

  def killed_mob
    map_movement.move_player(mob.location, player.location)

    player.location = mob.location
    player.update_exp(mob.level)

    messages = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green')]
    self.state = 1
    messages
  end

  def mob_attack
    player.health -= mob.damage
    messages = [Message.new("> #{mob.name} hits you for #{mob.damage}!", 'red')]

    # Mob kills player
    if player.health <= 0 && mob.health > 0
      messages << Message.new('> You died.', 'red')
      self.state = 1
      player.health = 0
    # player survives, next turn
    else
      messages << Message.new('> ATTACK | BAG | RUN', 'yellow') << Message.new('--> ', 'normal')
    end

    messages
  end

  def attempt_run
    if [*1..100].sample > 25
      messages = [Message.new('> Got away!', 'green')]
      self.state = 1
    else
      messages = [Message.new('> Couldn\'t escape!', 'red')]
      mob_attack.each { |result_msg| messages << result_msg }
    end

    messages
  end
end
