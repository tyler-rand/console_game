# battle between player and mob
class Battle
  attr_accessor :id, :state, :map_movement, :map, :player, :location, :mob

  #
  ## INSTANCE METHODS
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
      $message_win.message_log.append(user_input)

      msgs = case user_input
             when 'ATTACK'
               initiate_attack
             when 'BAG'
             when 'RUN'
               attempt_run
             else
               [Message.new('> Command not recognized, try again', 'red'),
                Message.new('> ATTACK | BAG | RUN', 'yellow'),
                Message.new('--> ', 'normal')]
             end

      $message_win.display_messages(msgs)
    end
  end

  private

  def find_mob
    map.mobs.find { |m| m.location == location }
  end

  def initiate_attack
    mob.health -= player.damage
    msgs = [Message.new("> You hit #{mob.name} for #{player.damage}!", 'green')]

    # Player kills mob
    if mob.health <= 0 && player.health > 0
      killed_mob.each { |result_msg| msgs << result_msg }
    # Mob attacks back
    else
      mob_attack.each { |result_msg| msgs << result_msg }
    end

    msgs
  end

  def killed_mob
    map_movement.move_player(mob.location, player.location)

    player.location = mob.location
    player.add_exp(mob.level)

    msgs = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green')]
    self.state = 1
    msgs
  end

  def mob_attack
    player.health -= mob.damage
    msgs = [Message.new("> #{mob.name} hits you for #{mob.damage}!", 'red')]

    if player.health <= 0 && mob.health > 0
      msgs << mob_kills_player
    else
      msgs << Message.new('> ATTACK | BAG | RUN', 'yellow') << Message.new('--> ', 'normal')
    end

    msgs
  end

  def attempt_run
    if [*1..100].sample > 25
      msgs = [Message.new('> Got away!', 'green')]
      self.state = 1
    else
      msgs = [Message.new('> Couldn\'t escape!', 'red')]
      mob_attack.each { |result_msg| msgs << result_msg }
    end

    msgs
  end

  def mob_kills_player
    msgs          = Message.new('> You died.', 'red')
    self.state    = 1
    player.health = 0
    map.current_map[player.location[0]][player.location[1]] = '.'
    player.location = []

    msgs
  end
end
