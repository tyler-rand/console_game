require 'curses'
require 'io/console'
require 'YAML'

# load models and helpers
Dir[File.join(__dir__, 'Models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'Helpers', '*.rb')].each { |file| require file }

class String
  # Output colors
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def titleize
    gsub(/\b./, &:upcase)
  end
end

################
### RUN GAME ###
################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

# Game initialized, no player created/loaded
@game = Game.new

loop do
  puts "\nEnter #{'NEW'.colorize(93)} for a new game, #{'LOAD'.colorize(93)} to resume progress, or #{'RULES'.colorize(93)} to learn how to play."
  print '-->'

  user_initialize_input = gets.chomp.upcase

  #
  ## NEW PLAYER
  #
  if user_initialize_input == 'NEW'
    @player = @game.new_player

  #
  ## LOAD PLAYER
  #
  elsif user_initialize_input == 'LOAD'
    @player = Player.load

  #
  ## RULES
  #
  elsif user_initialize_input == 'RULES'
    Game.show_rules

  #
  ## ADMIN
  #
  elsif user_initialize_input == 'ADMIN77'
    Game.admin_menu

  # user input error
  else
    puts 'Must enter \'NEW\', \'LOAD\', or \'RULES\'.'.colorize(101)
  end

  break if @player
end

########################################
### GAME STARTED/LOADED, MENU SCREEN ###
########################################

$message_log = MessageLog.new
screen = CursesScreen.new
@main_win, $message_win, @right_win = screen.build_display

begin
  loop do
    @main_win.refresh_display(@player.name)
    @right_win.build_display(@player)

    # main menu, query user for input
    messages = [Message.new('> MAP | BAG | EQUIPPED | STATS | SKILLS', 'yellow'), Message.new('--> ', 'normal')]
    $message_log.show_msgs(messages)

    user_menu_input = $message_win.win.getstr.upcase
    $message_log.append(user_menu_input)

    #
    ## MENU > MAP
    #
    if user_menu_input == 'MAP'
      # list maps
      @main_win.refresh_display(@player.name) { Map.list_all(@main_win) }

      # query user for map name to load, append it to last msg in log
      messages = [Message.new('> Enter a map name to load', 'yellow'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)
      map_name_input = $message_win.win.getstr.titleize
      $message_log.append(map_name_input)

      # check map name and build map
      map_name = Map.verify_name(map_name_input)
      @map = Map.load(map_name)
      @main_win.build_map(@map)
      @player.find_location(@map.current_map)

      messages = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
      $message_log.show_msgs(messages)

      # get input and move player loop
      loop do
        movement_input = @main_win.getch_no_echo
        map_movement = MapMovement.new(@map, @player, movement_input)
        break if @player.location == []
        map_movement.move
        @right_win.build_display(@player)
        @main_win.display_colored_map(@map)
      end

    #
    ## MENU > BAG
    #
    elsif user_menu_input == 'BAG'
      @main_win.refresh_display(@player.name) { @player.inventory.list(@main_win) }

      messages = [Message.new('> Enter a command and number seperated by a space (Ex. Equip 2)', 'yellow'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)

      user_bag_input = $message_win.win.getstr.split
      $message_log.append(user_bag_input.join(' '))

      command  = user_bag_input[0].downcase
      item_num = user_bag_input[1].to_i

      interaction = InventoryInteractor.new(@player, command, item_num)
      if command == 'equip'
        interaction.execute if interaction.equip_is_confirmed?
      else
        interaction.execute
      end

    #
    ## MENU > EQUIPPED
    #
    elsif user_menu_input == 'EQUIPPED'
      @player.equipped.list(@main_win)

    #
    ## MENU > STATS
    #
    elsif user_menu_input == 'STATS'
      # @player.show_stats

    #
    ## MENU > SKILLS
    #
    elsif user_menu_input == 'SKILLS'
      @player.show_skills

    # Menu input error
    else
      messages = [Message.new('> Error, command not recognized.', 'red')]
      $message_log.show_msgs(messages)
    end
  end
ensure
  Curses.close_screen
end
