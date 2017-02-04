# battle between player and mob
class Battle
  attr_reader :battle_displayer, :location, :map, :map_movement, :mob, :player
  attr_accessor :state

  ONGOING = 'ONGOING'.freeze
  COMPLETE = 'COMPLETE'.freeze

  def initialize(battle_displayer, map_movement)
    @id               = object_id
    @state            = ONGOING
    @battle_displayer = battle_displayer
    @map_movement     = map_movement
    @map              = map_movement.map
    @player           = map_movement.player
    @location         = map_movement.new_player_loc
    @mob              = find_mob
  end

  def engage
    loop do
      break if state == COMPLETE

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

    msgs = [
      Message.new('> ATTACK (A) | BAG (B) | RUN (R)', 'yellow'),
      Message.new('--> ', 'normal')
    ]
    $message_win.display_messages(msgs)

    user_input = $message_win.win.getstr.upcase
    $message_win.message_log.append(user_input)

    user_input
  end

  def choose_turn(turn)
    case turn
    when 'ATTACK', 'A' then attack_turn
    when 'BAG',    'B' then display_bag
    when 'RUN',    'R' then attempt_run
    else
      battle_input_error
    end
  end

  def attack_turn
    Attack.new(battle: self).player_attacks
  end

  def display_bag
    # TODO
  end

  def attempt_run
    [*1..100].sample > 25 ? got_away_safe : couldnt_escape
  end

  def got_away_safe
    battle_displayer.clear
    msgs = [
      Message.new('> Got away!', 'green'),
      Message.new('> ', 'normal')
    ]
    $message_win.display_messages(msgs)
    self.state = COMPLETE
  end

  def couldnt_escape
    $message_win.display_messages(Message.new('> Couldn\'t escape!', 'red'))
    Attack.new(battle: self).mob_attacks
  end

  def battle_input_error
    $message_win.display_messages(Message.new('> Command not recognized, try again.', 'red'))
  end
end
