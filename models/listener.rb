class Listener
  attr_reader :quest, :category, :type, :trigger, :progress

  def initialize(quest:)
    @quest    = quest.name
    @category = quest.triggers.first.keys.first
    @type     = quest.triggers.first.values.first.keys.first
    @trigger  = quest.triggers.first
    @progress = quest.progress
  end
end
