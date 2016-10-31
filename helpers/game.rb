def admin_menu
  print 'yup you found it -->'

  user_input = gets.chomp.split

  create_all_skills if user_input[0..1].map(&:upcase) == %w(CREATE SKILLS)
end

def create_all_skills
  skills_ary = [['Crit 1', 'Increases crit chance by 5%', 'incr_crit_chance'],
                ['Crit 2', 'Increases crit chance by 5%', 'incr_crit_chance'],
                ['Crit 3', 'Increases crit chance by 5%', 'incr_crit_chance'],
                ['Armor 1', 'Increases armor by 200', 'incr_armor'],
                ['Armor 2', 'Increases armor by 200', 'incr_armor']]

  skills_ary.each { |s| Skill.new(s[0], s[1], s[2]) }
end

def show_rules
  puts '<< game info/rules goes here >>'
end

def species_info
  puts ' -------------'
  puts ' --- HERO SPECIES ---'
  puts ' -------------'
  puts '<< hero species info goes here >>'
end

def type_info
  puts ' -------------'
  puts ' -- HERO CLASSES --'
  puts ' -------------'
  puts '<< hero class info goes here >>'
end

def prompt_player_create
  name = prompt_player_name
  species = prompt_player_species
  player_type = prompt_player_type
  password = prompt_player_pass

  player = Player.new(name: name, species: species, type: player_type, password: password)
  player.save
  player
end

def prompt_player_name
  puts "\nA new adventure begins... what's your character's name?"
  print '-->'

  player_attribute_loop('Name')
end

def prompt_player_species
  puts 'Next choose a species, each with their own unique benefits. (Ex: Human)'
  species_info
  print '-->'

  player_attribute_loop('Species')
end

def prompt_player_type
  puts "\nNext choose a class, each a different playstyle. (Ex: Warrior)"
  type_info
  print '-->'

  player_attribute_loop('Class')
end

def prompt_player_pass
  puts "\nAnd finally, enter a password so you can load your game."
  print '-->'

  player_attribute_loop('Password')
end

def player_attribute_loop(player_attribute)
  loop do
    attribute = gets.chomp
    break attribute unless attribute == ''
    puts "#{player_attribute} can't be blank!"
    print '-->'
  end
end

def load_player
  puts "\nEnter username:password (Ex: ghostpineapple:SA32es!sx)"
  print '-->'

  user_input = gets.chomp.split(':')
  input_name = user_input[0]
  input_pass = user_input[1]

  Player.load(input_name, input_pass)
end
