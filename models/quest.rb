class Quest
  attr_accessor :id, :level, :name, :location, :map_name, :requirements, :dialogue, :xp_reward,
                :cash_reward, :item_reward

  MAP_ICON = 'Q'.freeze

  # TODO: fix this ridiculousness
  def initialize(level:, name:, location:, map_name:, requirements:, dialogue:, xp_reward:,
                 cash_reward: 0, item_reward: nil)
    @id           = object_id
    @level        = level
    @name         = name
    @location     = location
    @map_name     = map_name
    @requirements = requirements
    @dialogue     = dialogue
    @xp_reward    = xp_reward
    @cash_reward  = cash_reward
    @item_reward  = item_reward
  end

  def self.find(map_name, location)
    Quest.all.find { |q| q.map_name == map_name && q.location == location }
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
