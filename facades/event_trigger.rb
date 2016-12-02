# base class for event triggers such as quest events, spawn mob, etc
class EventTrigger
  attr_accessor :player, :trigger

  # TRIGGER_CATEGORIES = %w(killed_mob map_location).freeze

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
      @listener = listener

      next unless listening_for_trigger_category?

      case @listener.category
      when :killed_mob
        check_killed_mob
      end
    end
  end

  def listening_for_trigger_category?
    @listener.category.to_s == @trigger[:category]
  end

  def check_killed_mob
    return unless listening_for_trigger?

    player.quest_log.update_progress(listener: @listener)
  end

  def listening_for_trigger?
    case @listener.type
    when :map
      listening_for_map?
    when :mob
      listening_for_mob?
    end
  end

  def listening_for_map?
    @listener.trigger[:killed_mob][:map] == @trigger[:mob].map_name.name
  end

  def listening_for_mob?
    @listener.trigger[:killed_mob][:mob] == @trigger[:mob].name
  end
end
