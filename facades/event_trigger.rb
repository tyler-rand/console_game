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
      @listener_trigger = listener[:triggers].first
      @listener_category = @listener_trigger.keys.first # ex. :killed_mob
      @listener_type = @listener_trigger.values.first.keys.first # :mob, or :map

      return unless listening_for_trigger_category?

      case @listener_category
      when :killed_mob
        check_killed_mob
      end
    end
  end

  def listening_for_trigger_category?
    @listener_category.to_s == @trigger[:category]
  end

  def check_killed_mob
    listening_for_trigger =
      case @listener_type
      when :map
        listening_for_map?
      when :mob
        listening_for_mob?
      end

    if listening_for_trigger
      player.quest_log.update_progress(listener: @listener)
    end
  end

  def listening_for_map?
    @listener_trigger[:killed_mob][:map] == @trigger[:mob].map_name.name
  end

  def listening_for_mob?
    @listener_trigger[:killed_mob][:mob] == @trigger[:mob].name
  end
end
