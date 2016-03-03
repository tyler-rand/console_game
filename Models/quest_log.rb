class QuestLog
  attr_accessor :id, :player, :quests

  def initialize(player:)
    @id = object_id
    @player = player
    @quests = []
  end

  def list(window)
    window.win.setpos(1, 2)
    window.win.addstr("---- #{player.name.upcase}\'s Quest Log ----")
    window.win.setpos(3, 3)

    display_quests(window.win)

    window.win.refresh
  end

  private

  def display_quests(win)
    quests.each do |quest|
      win.addstr("#{quest.name}, #{quest.map_name}")
      win.setpos(win.cury + 1, 3)
    end
  end
end
