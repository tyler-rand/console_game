# battle between player and mob
class Battle
  attr_accessor :id, :state, :battle_displayer, :map_movement, :map, :player, :location, :mob

  #
  ## INSTANCE METHODS
  #

  def initialize(battle_displayer, map_movement)
    @id               = object_id
    @state            = 0 # 0 is ongoing battle, 1 is battle ended
    @battle_displayer = battle_displayer
    @map_movement     = map_movement
    @map              = map_movement.map
    @player           = map_movement.player
    @location         = map_movement.new_player_loc
    @mob              = find_mob
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
    battle_displayer.refresh(self)

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

    if mob.health <= 0 && player.health > 0 then killed_mob else mob_attack end
  end

  def player_attack
    damage = adjusted_attack_damage(player, mob)
    mob.health -= damage
    battle_displayer.refresh(self)
    msgs = [Message.new("> You hit #{mob.name} for #{damage}!", 'green')]
    $message_win.display_messages(msgs)
  end

  def adjusted_attack_damage(attacker, defender)
    (attacker.damage * defense_adjusted_dmg_percent(defender)).round(0)
  end

  def defense_adjusted_dmg_percent(defender)
    defense = defender.defense
    count = 0
    while defense >= 20 do count += 1; defense -= 20 end
    defense_dmg_reduction_table[defender.level-1][count*20]
  end

  def defense_dmg_reduction_table
    [
      {'level' => 1, 0 => 1, 20 => 0.8, 40 => 0.6, 60 => 0.4, 80 => 0.2},
      {'level' => 2, 0 => 1, 40 => 0.8, 80 => 0.6, 120 => 0.4, 160 => 0.2},
      {'level' => 3, 0 => 1, 60 => 0.8, 120 => 0.6, 180 => 0.4, 240 => 0.2}
    ]
  end

  def killed_mob
    msgs = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green')]
    $message_win.display_messages(msgs)

    battle_displayer.clear
    map.remove_at_loc(location)
    player.add_exp(mob.level)

    self.state = 1

    map_movement.execute
  end

  def mob_attack
    damage = adjusted_attack_damage(mob, player)
    player.health -= damage
    battle_displayer.refresh(self)
    msgs = [Message.new("> #{mob.name} hits you for #{damage}!", 'red')]
    $message_win.display_messages(msgs)

    mob_kills_player if player.health <= 0 && mob.health > 0
  end

  def mob_kills_player
    battle_displayer.clear
    map.remove_at_loc(player.location)
    self.state      = 1
    player.health   = 0
    player.location = []

    msgs = [Message.new('> You died.', 'red')]
    $message_win.display_messages(msgs)
  end

  def attempt_run
    [*1..100].sample > 25 ? got_away_safe : couldnt_escape
  end

  def got_away_safe
    battle_displayer.clear
    msgs = [Message.new('> Got away!', 'green')]
    $message_win.display_messages(msgs)
    self.state = 1
  end

  def couldnt_escape
    msgs = [Message.new('> Couldn\'t escape!', 'red')]
    $message_win.display_messages(msgs)
    mob_attack
  end

  def battle_input_error
    msgs = [Message.new('> Command not recognized, try again.', 'red')]
    $message_win.display_messages(msgs)
  end
end
