# required for creating maps
require 'YAML'
require 'fileutils'

folders = %w(models facades)
folders.each { |folder| Dir[File.join(__dir__, folder, '*.rb')].each { |file| require file } }

FileUtils.mkdir('./db') unless File.exist?('./db')

# create db files
File.open('./db/PlayersDB.yml', 'w') {}
File.open('./db/MapsDB.yml', 'w') {}
File.open('./db/SkillsDB.yml', 'w') {}
File.open('./db/QuestsDB.yml', 'w') {}

# create quests
quests = [
  {
    name: 'Welcome to ConsoleRPG',
    level: 1,
    location: [13, 13],
    map_name: 'Trainers Court',
    requirements: { 'kills': 10 },
    start_text: '> Welcome to ConesoleRPG! Complete the first quest by getting 10 kills in Trainer\'s Court.',
    end_text: '> Good job completing your first quest!',
    xp_reward: 10,
    cash_reward: 100,
    item_reward: nil,
    triggers: [
      { killed_mob: { map: 'Trainers Court' } }
    ],
    progress: { kills: 0 }
  }
]
quests.each do |quest|
  Quest.new(name: quest[:name], level: quest[:level], location: quest[:location],
            map_name: quest[:map_name], requirements: quest[:requirements],
            start_text: quest[:start_text], end_text: quest[:end_text], xp_reward: quest[:xp_reward],
            cash_reward: quest[:cash_reward], item_reward: quest[:item_reward],
            triggers: quest[:triggers], progress: quest[:progress]).save
end

# create maps
maps = [
  { name: 'Trainers Court', level: 1, file: './maps/trainers_court.txt' },
  { name: 'Trainers Mansion', level: 2, file: './maps/trainers_mansion.txt' },
  { name: 'Road To City', level: 3, file: './maps/road_to_city.txt' }
]
maps.each { |map| Map.new(name: map[:name], level: map[:level], file: map[:file]).save }

puts 'Created files successfully!'
