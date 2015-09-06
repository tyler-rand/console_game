# game
class Game
  attr_accessor :id, :player

  #
  ## CLASS METHODS
  #

  def self.admin_menu
    print 'yup you found it -->'

    user_input = gets.chomp.split

    if user_input[0..1].map(&:upcase) == %w(NEW MAP)
      name    = user_input[2].split('_').map(&:capitalize).join(' ')
      level   = user_input[3]
      file    = user_input[4]

      new_map = Map.new(name: name, level: level, file: "maps/#{file}.txt")
      new_map.save
    end
  end

  def self.show_rules
    puts '<< game info/rules goes here >>'
  end

  def self.species_info
    puts ' -------------'
    puts ' --- HERO SPECIES ---'
    puts ' -------------'
    puts '<< hero species info goes here >>'
  end

  def self.type_info
    puts ' -------------'
    puts ' -- HERO CLASSES --'
    puts ' -------------'
    puts '<< hero class info goes here >>'
  end

  def self.prompt_player_name
    puts "\nA new adventure begins... what's your character's name?"
    print '-->'

    name = loop do
      name = gets.chomp.capitalize
      break name unless name == ''
      puts 'You need a name!'
      print '-->'
    end

    puts "\n#{name} it is!"

    name
  end

  def self.prompt_player_species
    puts 'Next choose a species, each with their own unique benefits. (Ex: Human)'
    Game.species_info
    print '-->'

    species = loop do
      species = gets.chomp.capitalize
      break species unless species == ''
      puts 'Choose a species!'
      print '-->'
    end

    species
  end

  def self.prompt_player_type
    puts "\nNext choose a class, each a different playstyle. (Ex: Warrior)"
    Game.type_info
    print '-->'

    player_type = loop do
      player_type = gets.chomp.capitalize
      break player_type unless player_type == ''
      puts 'Gotta choose a class!'
      print '-->'
    end

    player_type
  end

  def self.prompt_player_pass
    puts "\nAnd finally, enter a password so you can load your game."
    print '-->'

    password = loop do
      password = gets.chomp
      break password unless password == ''
      puts 'Password can\'t be blank!'
      print '-->'
    end

    password
  end
end
