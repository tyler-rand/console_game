class Quest
  attr_accessor :id, :level, :name, :start_location, :map_name, :requirements, :start_text, :end_text, :xp_reward,
                :cash_reward, :item_reward, :triggers, :progress

  MAP_ICON = 'Q'.freeze

  # TODO: fix this ridiculousness
  def initialize(level:, name:, start_location:, map_name:, requirements:, start_text:, end_text:,
                 xp_reward:, cash_reward: 0, item_reward: nil, triggers: [], progress:)
    @id             = object_id
    @level          = level
    @name           = name
    @start_location = start_location
    @map_name       = map_name
    @requirements   = requirements
    @start_text     = start_text
    @end_text       = end_text
    @xp_reward      = xp_reward
    @cash_reward    = cash_reward
    @item_reward    = item_reward
    @triggers       = triggers
    @progress       = progress
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

  private

  def item_reward_string
    item_reward.nil? ? '.' : ", #{item_reward}"
  end
end
