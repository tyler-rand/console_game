# game
class Game
  attr_accessor :id, :state, :player

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

  def initialize()
    @id     = object_id
    @state  = 0
    @player = nil
  end

  def new_player
    puts "\nA new adventure begins... what's your character's name?"
    print '-->'

    name = gets.chomp.capitalize

    puts "#{name} it is! Next choose a species and a class, each with their own unique benefits."
    Player.species_info
    Player.type_info
    puts "\nEnter your species then class seperated by a space. (Ex: Human Warrior)"
    print '-->'

    species_type = gets.chomp.split(' ')
    species      = species_type[0].capitalize
    type         = species_type[1].capitalize

    puts "\nAnd finally, enter a password so you can load your game."
    print '-->'

    password = gets.chomp
    player   = Player.new(name: name, species: species, type: type, password: password)

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

  def load_map
    maps = Map.list_all
    map  = nil

    while map.nil? do
      puts "\nEnter a map name to load"
      print '-->'

      user_input = gets.chomp

      maps.map do |m|
        map = m if m.name.upcase == user_input.upcase
      end

      puts 'Map name not recognized.'.colorize(101) if map == nil
    end

    map
  end

end
