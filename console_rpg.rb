require 'curses'
require 'io/console'
require 'YAML'

# load models and helpers
Dir[File.join(__dir__, 'Models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'Helpers', '*.rb')].each { |file| require file }

# Output colors
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

################
### RUN GAME ###
################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

# Game initialized, no player created/loaded
@game = Game.new

while @game.state == 0 do # initial state is 0
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
    @player = @game.load_player

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

@screen = CursesScreen.new
@main_win, @messages_win, @right_win = @screen.build_display

begin
  while @game.state == 1 do
    @main_win.win.clear
    @main_win.box_with_player_name(@player.name)
    @main_win.win.refresh

    @right_win.build_display(@player)

    # main menu, query user for input
    messages = ['> MAP | BAG | EQUIPPED | STATS | SKILLS', '--> ']
    @game.message_log.add_msgs(messages)
    @messages_win.display_messages(@game.message_log)

    # append user input to last message in log, to show as output
    user_menu_input = @messages_win.win.getstr.upcase
    @game.message_log.log[-1][0] += user_menu_input

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
      messages = ['> Enter a map name to load', '--> ']
      @game.message_log.add_msgs(messages)
      @messages_win.display_messages(@game.message_log)

      # append user input to last message in log, to show as output
      map_name_input = @messages_win.win.getstr
      @game.message_log.log[-1][0] += map_name_input

      # initialize map
      @map = @game.load_map(map_name_input)
      @player.set_location(@map.current_map)

      # build map in window
      @main_win.build_map(@map)
      @main_win.win.setpos(24, 2)

      # print map load success
      messages = ["> #{@map.name} loaded successfully, player: #{@player.location}"]
      @game.message_log.add_msgs(messages)
      @messages_win.display_messages(@game.message_log)

      # get input and move player loop
      while @player.location != []
        @messages_win.win.refresh
        Curses.noecho
        Curses.curs_set(0)
        user_movement_input = @main_win.win.getch
        Curses.curs_set(1)
        Curses.echo

        # determine new player location from current location and movement input
        new_player_loc = @map.new_player_loc_from_input(@player, user_movement_input)

        unless @player.location == [] # probably a better way to do this
          @messages_win.win.setpos(2, 2)
          messages = @map.move_player(player: @player, new_player_loc: new_player_loc)

          # if movement produces any messages, add to the log
          unless messages.empty?
            @game.message_log.add_msgs(messages)
            @messages_win.win.clear
          end

          # display updated messages from most recent player movement
          @messages_win.print_log(@game.message_log)
          @messages_win.box_with_title
          @messages_win.win.refresh

          # show updated map with player movement
          @main_win.display_colored_map(@map)
          @main_win.win.setpos(24, 2)
        end
      end

    #
    ## MENU > BAG
    #
    elsif user_menu_input == 'BAG'
      @player.inventory.list(@main_win)
      messages = ['> Enter a command and number seperated by a space (Ex. Equip 2)', '--> ']
      @game.message_log.add_msgs(messages)
      @messages_win.display_messages(@game.message_log)

      user_bag_input = @messages_win.win.getstr.split(' ')

      # append user input to last message in log, to show as output
      @game.message_log.log[-1][0] += user_bag_input.join(' ')

      command  = user_bag_input[0].upcase
      item_num = user_bag_input[1].to_i

      messages = @player.inventory.interact_with_item(command, item_num)
      @game.message_log.add_msgs(messages)
      @messages_win.display_messages(@game.message_log)

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
      messages = ['> Error, command not recognized.']
      @game.message_log.add_msgs(messages)
      @messages_win.display_messages(@game.message_log)
    end
  end
ensure
  Curses.close_screen
end
