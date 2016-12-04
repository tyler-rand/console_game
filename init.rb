require 'YAML'
require 'fileutils'

seeds = %w(mobs quests quest_items)
seeds.each { |seed| load "seeds/#{seed}.rb" }

folders = %w(models facades)
folders.each { |folder| Dir[File.join(__dir__, folder, '*.rb')].each { |file| require file } }

###################
# CREATE DB FILES #
###################

FileUtils.mkdir('./db') unless File.exist?('./db')
File.open('./db/PlayersDB.yml', 'w') {}
File.open('./db/MapsDB.yml', 'w') {}
File.open('./db/MobsDB.yml', 'w') {}
File.open('./db/SkillsDB.yml', 'w') {}
File.open('./db/QuestsDB.yml', 'w') {}

#################
# CREATE QUESTS #
#################

QUESTS.each do |quest|
  item_reward = QUEST_ITEMS.detect { |x| x[:name] == quest[:item_reward] }

  item =
    unless item_reward.nil?
      if item_reward[:type] == 'weapon'
        WeaponItem.new(
          {
            ilvl:    item_reward[:ilvl],
            name:    item_reward[:name],
            type:    item_reward[:type],
            quality: item_reward[:quality],
            value:   item_reward[:value]
          },
          damage: item_reward[:damage],
          speed:  item_reward[:speed]
        )
      else
        ArmorItem.new(
          {
            ilvl:    item_reward[:ilvl],
            name:    item_reward[:name],
            type:    item_reward[:type],
            quality: item_reward[:quality],
            value:   item_reward[:value]
          },
          defense: item_reward[:defense]
        )
      end
    end

  quest_args = {
    name:           quest[:name],
    level:          quest[:level],
    start_location: quest[:start_location],
    map_name:       quest[:map_name],
    requirements:   quest[:requirements],
    start_text:     quest[:start_text],
    end_text:       quest[:end_text],
    xp_reward:      quest[:xp_reward],
    cash_reward:    quest[:cash_reward],
    item_reward:    item,
    triggers:       quest[:triggers],
    progress:       quest[:progress]
  }
  Quest.new(quest_args).save
end

#####################
# CREATE NAMED MOBS #
#####################

MOBS.each do |mob|
  Mob.new(
    map:      mob[:map_name],
    location: mob[:location],
    options:  mob[:options]
  ).save
end

###############
# CREATE MAPS #
###############

maps = [
  { name: 'Trainers Court',   level: 1, file: './maps/trainers_court.txt' },
  { name: 'Trainers Mansion', level: 2, file: './maps/trainers_mansion.txt' },
  { name: 'Road To City',     level: 3, file: './maps/road_to_city.txt' }
]

maps.each do |map|
  Map.new(
    name:  map[:name],
    level: map[:level],
    file:  map[:file]
  ).save
end

puts 'Created files successfully!'
