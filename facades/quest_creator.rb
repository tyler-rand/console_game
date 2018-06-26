# creates quests for the init script
class QuestCreator
  def self.run
    new.run
  end

  def run
    create_all_quests
    puts "Created #{Quest.all.count} quests!"
  end

  private

  def create_all_quests
    QUESTS.each { |quest| Quest.create(build_quest_args(quest)) }
  end

  def build_quest_args(quest)
    quest_reward = QUEST_ITEMS.detect { |x| x[:name] == quest[:item_reward] }
    {
      name:           quest[:name],
      level:          quest[:level],
      start_location: quest[:start_location],
      map_name:       quest[:map_name],
      requirements:   quest[:requirements],
      start_text:     quest[:start_text],
      end_text:       quest[:end_text],
      xp_reward:      quest[:xp_reward],
      cash_reward:    quest[:cash_reward],
      item_reward:    determine_item_reward(quest_reward),
      triggers:       quest[:triggers],
      progress:       quest[:progress]
    }
  end

  def determine_item_reward(quest_reward)
    if quest_reward.nil?
      nil
    elsif quest_reward[:type] == 'weapon'
      WeaponItem.new(
        item_args(quest_reward),
        damage: quest_reward[:damage],
        speed:  quest_reward[:speed]
      )
    else
      ArmorItem.new(
        item_args(quest_reward),
        defense: quest_reward[:defense]
      )
    end
  end

  def item_args(item_reward)
    {
      ilvl:    item_reward[:ilvl],
      name:    item_reward[:name],
      type:    item_reward[:type],
      quality: item_reward[:quality],
      value:   item_reward[:value]
    }
  end
end
