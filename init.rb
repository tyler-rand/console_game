# required for creating maps
require 'YAML'
require 'FileUtils'
Dir[File.join(__dir__, 'Models', '*.rb')].each { |file| require file }
FileUtils.mkdir('./db') unless File.exist?('./db')

# create db files
File.open('./db/PlayersDB.yml', 'w') {}
File.open('./db/MapsDB.yml', 'w') {}
File.open('./db/SkillsDB.yml', 'w') {}
File.open('./db/QuestsDB.yml', 'w') {}

# create quests
Quest.new(name: 'Welcome', level: 1, location: [13, 13], map_name: 'Trainers Court', requirements: { 'kills': 10 },
          dialogue: '> Welcome to ConesoleRPG! Complete the first quest by getting 10 kills in Trainer\'s Court.',
          xp_reward: 10,  cash_reward: 100, item_reward: nil).save

# create maps
Map.new(name: 'Trainers Court', level: 1, file: './maps/trainers_court.txt').save
Map.new(name: 'Trainers Mansion', level: 2, file: './maps/trainers_mansion.txt').save
Map.new(name: 'Road To City', level: 3, file: './maps/road_to_city.txt').save

puts 'Created files successfully!'
