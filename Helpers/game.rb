def admin_menu
  print 'yup you found it -->'

  user_input = gets.chomp.split

  return unless user_input[0..1].map(&:upcase) == %w(NEW MAP)
  name    = user_input[2].split('_').map(&:capitalize).join(' ')
  level   = user_input[3]
  file    = user_input[4]

  new_map = Map.new(name: name, level: level, file: "maps/#{file}.txt")
  new_map.save
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

  loop do
    name = gets.chomp.capitalize
    break name unless name == ''
    puts 'You need a name!'
    print '-->'
  end
end

def prompt_player_species
  puts 'Next choose a species, each with their own unique benefits. (Ex: Human)'
  species_info
  print '-->'

  loop do
    species = gets.chomp.capitalize
    break species unless species == ''
    puts 'Choose a species!'
    print '-->'
  end
end

def prompt_player_type
  puts "\nNext choose a class, each a different playstyle. (Ex: Warrior)"
  type_info
  print '-->'

  loop do
    player_type = gets.chomp.capitalize
    break player_type unless player_type == ''
    puts 'Gotta choose a class!'
    print '-->'
  end
end

def prompt_player_pass
  puts "\nAnd finally, enter a password so you can load your game."
  print '-->'

  loop do
    password = gets.chomp
    break password unless password == ''
    puts 'Password can\'t be blank!'
    print '-->'
  end
end

def load_player
  puts "\nEnter username:password (Ex: ghostpineapple:SA32es!sx)"
  print '-->'

  user_input = gets.chomp.split(':')
  input_name = user_input[0].capitalize
  input_pass = user_input[1]

  Player.load(input_name, input_pass)
end
