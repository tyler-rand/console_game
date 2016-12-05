# quest which a player accepts and complets for item, cash, & xp rewards
class Quest
  attr_reader :cash_reward, :end_text, :id, :item_reward, :level, :map_name, :name, :requirements,
              :start_location, :start_text, :triggers, :xp_reward
  attr_accessor :progress

  MAP_ICON = 'Q'.freeze

  def initialize(args)
    @id             = args[:object_id]
    @level          = args[:level]
    @name           = args[:name]
    @start_location = args[:start_location]
    @map_name       = args[:map_name]
    @requirements   = args[:requirements]
    @start_text     = args[:start_text]
    @end_text       = args[:end_text]
    @xp_reward      = args[:xp_reward]
    @cash_reward    = args[:cash_reward]
    @item_reward    = args[:item_reward]
    @triggers       = args[:triggers]
    @progress       = args[:progress]
  end

  def self.find(map_name, start_location)
    Quest.all.find { |q| q.map_name == map_name && q.start_location == start_location }
  end

  def self.all
    YAML.load_stream(open('db/QuestsDB.yml'))
  end

  def save
    File.open('db/QuestsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def formatted_rewards
    "> Rewards: #{xp_reward} XP, #{cash_reward} gold#{item_reward_string}"
  end

  def completed?
    progress == requirements
  end

  private

  def item_reward_string
    if item_reward.nil?
      '.'
    else
      ", #{item_reward.name}"
    end
  end
end
