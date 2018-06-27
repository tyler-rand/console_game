  require "pry"
# keeps track of what quests a player has, as well as their progress
class QuestLog
  attr_reader :player
  attr_accessor :quests, :completed_quests

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

  def add(quest)
    quests << quest
    player.listeners << Listener.new(quest: quest)
    display_add_quest_text(quest)
  end

  def update_progress(listener:)
    quest = quests.detect { |q| q.name == listener.quest }
    raise 'kerplosion' if quest.nil?

    $message_win.display_messages(Message.new("quest count: #{quests.count}", 'green'))
    $message_win.display_messages(Message.new("listener.quest = #{listener.quest}", 'red'))
    $message_win.display_messages(Message.new("quest var = #{quest}", 'green'))
    sleep 2


    if quest
      case listener.category
      when :killed_mob
        if listener.type == :map
          quest.progress[:kills] += 1
        else
          quest.progress[:mob_killed] += 1
        end
      end

      complete_quest(quest) if quest.completed?
    else
      Curses.close_screen
      binding.pry
    end
  end

  private

  def display_quests(win)
    quests.each do |quest|
      win.addstr("#{quest.name}, #{quest.map_name}")
      win.setpos(win.cury, 3)
      win.addstr(
        "#{quest.progress.keys.first.to_s.gsub('_', ' ').capitalize}: " \
        "#{quest.progress.values.first}/#{quest.requirements.values.first}"
      )
      win.setpos(win.cury + 1, 3)
    end
  end

  def display_add_quest_text(quest)
    msgs = [Message.new(quest.start_text, 'yellow'),
            Message.new(quest.formatted_rewards, 'yellow')]
    $message_win.display_messages(msgs)
  end

  def complete_quest(quest)
    display_completed_quest_text(quest)
    player.add_quest_rewards(quest)
    log_completed_quest(quest)
    player.save
  end

  def log_completed_quest(quest)
    # add msg to log
    binding.pry
    completed_quests << quest.name
    player.listeners.delete_if { |listener| listener.quest == quest.name }
    quests.delete_if { |q| q.id == quest.id }
  end

  def display_completed_quest_text(quest)
    msgs = [Message.new("> Quest Completed - #{quest.name}", 'green'),
            Message.new(quest.formatted_rewards, 'green'),
            Message.new(quest.end_text, 'green')]
    $message_win.display_messages(msgs)
  end
end
