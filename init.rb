# required for creating maps
require 'YAML'
require 'FileUtils'
require './Models/map.rb'
require './Models/mob.rb'

FileUtils.mkdir('./db') unless File.exists?('./db')

# create db files
File.open('./db/PlayersDB.yml', 'w') {}
File.open('./db/MapsDB.yml', 'w') {}
File.open('./db/SkillsDB.yml', 'w') {}

# create maps
Map.new(name: 'Trainers Court', level: 1, file: "./maps/trainers_court.txt").save
Map.new(name: 'Trainers Mansion', level: 2, file: "./maps/trainers_mansion.txt").save
Map.new(name: 'Road To City', level: 3, file: "./maps/road_to_city.txt").save
