# game
class Game
  attr_accessor :id, :state, :player, :message_log

  #
  ## CLASS METHODS
  #

  def self.admin_menu
    print 'yup you found it -->'
    
    user_input = gets.chomp.split(' ')

    if user_input[0..1].map(&:upcase) == %w(NEW MAP)
      name    = user_input[2].split('_').map(&:capitalize).join(' ')
      level   = user_input[3]
      file    = user_input[4]

      new_map = Map.new(name: name, level: level, file: "maps/#{file}.txt")
      new_map.save

    elsif user_input[0, 1] == %w(NEW ITEM)
      name           = user_input[2]
      type           = user_input[3]
      attributes_ary = user_input.shift(4)

      attr_names     = attributes_ary.select.each_with_index { |_, i| i.even? }
      attr_values    = attributes_ary.select.each_with_index { |_, i| i.odd? }
      attributes     = Hash[attr_names.zip(attr_values)]

      item           = Item.new(name, type, *attributes)
      item.save
    end
  end

  def self.show_rules
    puts "how to play..."
  end

  #
  ## INSTANCE METHODS
  #

  def initialize
    @id     = object_id
    @state  = 0
    @player = nil
    @message_log = MessageLog.new(game: self)
  end

  def new_player
    puts "\nA new adventure begins... what's your character's name?"
    print '-->'

    # name player
    name = gets.chomp.capitalize
    while name == '' do
      puts 'Hey we need a name!'
      print '-->'
      name = gets.chomp.capitalize
    end

    puts "#{name} it is! Next choose a species, each with their own unique benefits. (Ex: Human)"
    Player.species_info
    print '-->'

    # choose species
    species = gets.chomp.capitalize
    while species == '' do
      puts 'Choose a species!'
      print '-->'
      species = gets.chomp.capitalize
    end

    puts "\nNext choose a class. (Ex: Warrior)"
    Player.type_info
    print '-->'

    # choose type
    player_type = gets.chomp.capitalize
    while player_type == '' do
      puts 'Gotta choose a class!'
      print '-->'
      player_type = gets.chomp.capitalize
    end

    puts "\nAnd finally, enter a password so you can load your game."
    print '-->'

    password = gets.chomp
    player   = Player.new(name: name, species: species, type: player_type, password: password)

    player.save
    player
  end

  def load_player
    puts "\nEnter username:password (Ex: ghostpineapple:SA32es!sx)"
    print '-->'

    user_input = gets.chomp.split(':')
    input_name = user_input[0].capitalize
    input_pass = user_input[1]

    player     = Player.load_by_credentials(input_name, input_pass)
    player
  end

  def load_map(user_input)
    maps = Map.all
    map  = maps.find { |m| m.name.upcase == user_input.upcase }
    map
  end

end
