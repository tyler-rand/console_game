# base class for event triggers such as quest events, spawn mob, etc
class EventTrigger
  attr_accessor :player, :trigger

  TRIGGER_TYPES = %w(killed_mob map_location).freeze

  def initialize(player:, trigger:)
    @player  = player
    @trigger = trigger
  end

  def execute
    check_player_listeners
  end

  private

  def check_player_listeners
    player.listeners.each do |listener|
      trigger_type = listener[:triggers].first.keys.first # ex. :killed_mob

      return unless listening_for_trigger_type?(trigger_type)

      case trigger_type
      when :killed_mob
        check_killed_mob(listener)
      end
    end
  end

  def listening_for_trigger_type?(trigger_type)
    trigger_type.to_s == @trigger[:type]
  end

  def check_killed_mob(listener)
    trigger = listener[:triggers].first

    trigger[:killed_mob].keys.each do |matcher|
      if listening_for_map?(matcher, trigger)
        player.quest_log.update_progress(
          quest_name: listener[:quest], trigger_type: trigger.keys.first
        )
      end
    end
  end

  def listening_for_map?(matcher, trigger)
    matcher == :map && trigger[:killed_mob][:map] == @trigger[:mob].map_name.name
  end
end
