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
    split.map(&:capitalize).join(' ')
  end
end

################
### RUN GAME ###
################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

# Game initialized, no player created/loaded
@game = Game.new

while @game.state == 0 # initial state is 0
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

  @game.state = 1 if @player
end

########################################
### GAME STARTED/LOADED, MENU SCREEN ###
########################################

$message_log = MessageLog.new
screen = CursesScreen.new
@main_win, $message_win, @right_win = screen.build_display

begin
  while @game.state == 1
    @main_win.win.clear
    @main_win.box_with_player_name(@player.name)
    @main_win.win.refresh

    @right_win.build_display(@player)

    # main menu, query user for input
    messages = [Message.new('> MAP | BAG | EQUIPPED | STATS | SKILLS', 'yellow'), Message.new('--> ', 'normal')]
    $message_log.show_msgs(messages)

    # append user input to last message in log, to show as output
    user_menu_input = $message_win.win.getstr.upcase
    $message_log.log[-1][0] += user_menu_input

    #
    ## MENU > MAP
    #
    if user_menu_input == 'MAP'
      # list maps
      @main_win.win.clear
      Map.list_all(@main_win)
      @main_win.box_with_player_name(@player.name)
      @main_win.win.refresh

      # query user for map name to load
      messages = [Message.new('> Enter a map name to load', 'yellow'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)

      # get user input and append it to last message in log, to show as entered
      map_name_input = $message_win.win.getstr.titleize
      $message_log.log[-1][0] += map_name_input

      # check if map name input is in list of maps
      unless Map.names_ary.include?(map_name_input)
        loop do
          break if Map.names_ary.include?(map_name_input)
          messages = [Message.new('> Map name error, try again.', 'red'), Message.new('--> ', 'normal')]
          $message_log.show_msgs(messages)
          map_name_input = $message_win.win.getstr.titleize
          $message_log.log[-1][0] += map_name_input
        end
      end

      # initialize map
      @map = Map.load(map_name_input)
      @player.set_location(@map.current_map)

      # build map in window
      @main_win.build_map(@map)
      @main_win.win.setpos(24, 2)

      # print map load success
      messages = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
      $message_log.show_msgs(messages)

      # get input and move player loop
      while @player.location != []
        $message_win.win.refresh
        Curses.noecho
        Curses.curs_set(0)
        user_movement_input = @main_win.win.getch
        Curses.curs_set(1)
        Curses.echo

        # determine new player location from current location and movement input
        messages, new_player_loc = @map.new_player_loc_from_input(@player, user_movement_input)
        $message_log.show_msgs(messages)

        unless @player.location == [] # probably a better way to do this
          messages, action = @map.move_player(player: @player, new_player_loc: new_player_loc) { @right_win.build_display(@player) }

          $message_log.show_msgs(messages)

          # process any action from player movement
          if action == 'engage_mob'
            @player.engage_mob(@map, new_player_loc) { @right_win.build_display(@player) }
          end

          # show updated map with new player loc
          @main_win.display_colored_map(@map)
          @main_win.win.setpos(24, 2)
        end
      end

    #
    ## MENU > BAG
    #
    elsif user_menu_input == 'BAG'
      @player.inventory.list(@main_win)
      messages = [Message.new('> Enter a command and number seperated by a space (Ex. Equip 2)', 'yellow'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)

      user_bag_input = $message_win.win.getstr.split
      $message_log.log[-1][0] += user_bag_input.join(' ')

      command  = user_bag_input[0].downcase
      item_num = user_bag_input[1].to_i
      item = nil
      @player.inventory.items.each { |x, i| item = x if item_num == i }

      interaction = InventoryInteractor.new(@player, command, item, item_num)
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
