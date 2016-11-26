# keeps track of what quests a player has, as well as their progress
class QuestLog
  attr_accessor :id, :player, :quests, :completed_quests

  def initialize(player:)
    @id        = object_id
    @player    = player
    @quests    = []
    @completed_quests = []
  end

  def list(window)
    window.win.setpos(1, 2)
    window.win.addstr("---- #{player.name.upcase}\'s Quest Log ----")
    window.win.setpos(3, 3)

    display_quests(window.win)

    window.win.refresh
  end

  # adds a quest and its event triggers to QuestLog
  def add(quest)
    quests << quest
    player.listeners << { quest: quest.name, triggers: quest.triggers, progress: quest.progress }

    display_add_quest_text(quest)
  end

  def update_progress(listener:)
    quest = quests.detect { |quest| quest.name == listener[:quest] }
    listener_category = listener[:triggers].first.keys.first
    listener_type = listener[:triggers].first.values.first.keys.first

    case listener_category
    when :killed_mob
      if listener_type == :map
        quest.progress[:kills] += 1
      else
        quest.progress[:mob_killed] += 1
      end
    end

    complete_quest(quest) if quest_completed?(quest)
  end

  private

  def display_quests(win)
    quests.each do |quest|
      win.addstr("#{quest.name}, #{quest.map_name}")
      win.setpos(win.cury, 3)
      win.addstr("#{quest.progress.keys.first.to_s.gsub('_', ' ').capitalize}: #{quest.progress.values.first}/#{quest.requirements.values.first}")
      win.setpos(win.cury + 1, 3)
    end
  end

  def display_add_quest_text(quest)
    msgs = [Message.new(quest.start_text, 'yellow'),
            Message.new(quest.formatted_rewards, 'yellow')]
    $message_win.display_messages(msgs)
  end

  def quest_completed?(quest)
    quest.progress == quest.requirements
  end

  def complete_quest(quest)
    display_completed_quest_text(quest)
    player.add_quest_rewards(quest)
    update_log_completed_quest(quest)
    player.save
  end

  def update_log_completed_quest(quest)
    completed_quests << quest.name
    player.listeners.delete_if { |listener| listener[:quest] == quest.name }
    quests.delete_if { |q| q.id == quest.id }
  end

  def display_completed_quest_text(quest)
    msgs = [Message.new("> Quest Completed - #{quest.name}", 'green'),
            Message.new(quest.formatted_rewards, 'green'),
            Message.new(quest.end_text, 'green')]
    $message_win.display_messages(msgs)
  end
end
