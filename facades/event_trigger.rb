# base class for event triggers such as quest events, spawn mob, etc
class EventTrigger
  attr_accessor :player, :trigger

  TRIGGER_TYPES = %w(killed_mob map_location).freeze

  def initialize(player:, trigger:)
    @player  = player
    @trigger = trigger
  end

  def execute
    if trigger.keys.first == :killed_mob # possibly others
      check_player_quest_log
    end
  end

  private

  def check_player_quest_log
    if player.quest_log.listeners.detect { |listener| listener[:triggers].include?(trigger) }
      player.quest_log.update_progress(trigger)
    end
  end
end
