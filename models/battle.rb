# battle between player and mob
class Battle
  attr_accessor :state, :battle_displayer, :map_movement, :map, :player, :location, :mob

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
      display_bag
    when 'RUN'
      attempt_run
    else
      battle_input_error
    end
  end

  def attack_turn
    AttackTurn.new(battle: self).execute
  end

  def display_bag
    #
  end

  def attempt_run
    [*1..100].sample > 25 ? got_away_safe : couldnt_escape
  end

  def got_away_safe
    battle_displayer.clear
    msgs = [Message.new('> Got away!', 'green'),
            Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
    self.state = 1
  end

  def couldnt_escape
    $message_win.display_messages(Message.new('> Couldn\'t escape!', 'red'))
    mob_attack
  end

  def battle_input_error
    $message_win.display_messages(Message.new('> Command not recognized, try again.', 'red'))
  end
end
