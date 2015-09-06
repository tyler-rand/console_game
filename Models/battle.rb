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

      user_input = prompt_battle_input

      choose_turn(user_input)
    end
  end

  private

  def find_mob
    map.mobs.find { |m| m.location == location }
  end

  def prompt_battle_input
    msgs = [Message.new('> ATTACK | BAG | RUN', 'yellow'), Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    user_input = $message_win.win.getstr.upcase
    $message_win.message_log.append(user_input)

    user_input
  end

  def choose_turn(turn)
    case turn
    when 'ATTACK'
      attack_turn
    when 'BAG'
    when 'RUN'
      attempt_run
    else
      battle_input_error
    end
  end

  def attack_turn
    player_attack

    mob.health <= 0 && player.health > 0 ? killed_mob : mob_attack_turn
  end

  def player_attack
    mob.health -= player.damage
    msgs = [Message.new("> You hit #{mob.name} for #{player.damage}!", 'green')]
    $message_win.display_messages(msgs)
  end

  def killed_mob
    msgs = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green')]
    $message_win.display_messages(msgs)

    map.remove_at_loc(location)

    player.add_exp(mob.level)

    self.state = 1

    map_movement.execute
  end

  def mob_attack_turn
    mob_attack

    mob_kills_player if player.health <= 0 && mob.health > 0
  end

  def mob_attack
    player.health -= mob.damage
    msgs = [Message.new("> #{mob.name} hits you for #{mob.damage}!", 'red')]
    $message_win.display_messages(msgs)
  end

  def mob_kills_player
    map.remove_at_loc(player.location)
    self.state      = 1
    player.health   = 0
    player.location = []

    msgs = [Message.new('> You died.', 'red')]
    $message_win.display_messages(msgs)
  end

  def attempt_run
    if [*1..100].sample > 25
      msgs = [Message.new('> Got away!', 'green')]
      $message_win.display_messages(msgs)
      self.state = 1
    else
      msgs = [Message.new('> Couldn\'t escape!', 'red')]
      $message_win.display_messages(msgs)
      mob_attack
    end
  end

  def battle_input_error
    msgs = [Message.new('Command not recognized, try again.', 'red')]
    $message_win.display_messages(msgs)
  end
end
