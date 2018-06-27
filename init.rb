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

QuestCreator.run

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

#####################
# CREATE NAMED MOBS #
#####################

MOBS.each do |mob|
  Mob.new(
    map:      Map.load(mob[:map_name]),
    location: mob[:location],
    options:  mob[:options]
  ).save
end


puts 'Created files successfully!'
