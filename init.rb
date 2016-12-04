require 'YAML'
require 'fileutils'

seeds = %w(mobs quests quest_items)
seeds.each { |seed| load "seeds/#{seed}.rb" }

folders = %w(models facades)
folders.each { |folder| Dir[File.join(__dir__, folder, '*.rb')].each { |file| require file } }

FileUtils.mkdir('./db') unless File.exist?('./db')

# create db files
File.open('./db/PlayersDB.yml', 'w') {}
File.open('./db/MapsDB.yml', 'w') {}
File.open('./db/MobsDB.yml', 'w') {}
File.open('./db/SkillsDB.yml', 'w') {}
File.open('./db/QuestsDB.yml', 'w') {}

# create quests
QUESTS.each do |quest|
  item_reward = QUEST_ITEMS.detect{|x| x[:name] == quest[:item_reward]}
  item =
    if item_reward == nil
      nil
    else
      ArmorItem.new(
        {ilvl: item_reward[:ilvl],
        name: item_reward[:name],
        type: item_reward[:type],
        quality: item_reward[:quality],
        value: item_reward[:value]},
        defense: item_reward[:defense]
      )
    end

  Quest.new(name: quest[:name], level: quest[:level], start_location: quest[:start_location],
            map_name: quest[:map_name], requirements: quest[:requirements],
            start_text: quest[:start_text], end_text: quest[:end_text], xp_reward: quest[:xp_reward],
            cash_reward: quest[:cash_reward], item_reward: item,
            triggers: quest[:triggers], progress: quest[:progress]).save
end

# create named mobs
MOBS.each do |mob|
  Mob.new(map: mob[:map_name], location: mob[:location], options: mob[:options]).save
end

# create maps
maps = [
  { name: 'Trainers Court', level: 1, file: './maps/trainers_court.txt' },
  { name: 'Trainers Mansion', level: 2, file: './maps/trainers_mansion.txt' },
  { name: 'Road To City', level: 3, file: './maps/road_to_city.txt' }
]
maps.each { |map| Map.new(name: map[:name], level: map[:level], file: map[:file]).save }

puts 'Created files successfully!'
