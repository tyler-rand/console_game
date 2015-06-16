require 'curses'
require 'io/console'
require 'YAML'

# load models, helpers
Dir[File.join(__dir__, 'Models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'Helpers', '*.rb')].each { |file| require file }

# Output colors
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

##################
### RUN GAME ###
##################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

@game = Game.new() # Game started, no player loaded

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

#
## GAME STARTED OR LOADED, MENU SCREEN
#
while @game.state == 1 do
  begin
    @screen = CursesScreen.new
    @map_win, @messages_win, @right_win = @screen.build_display

    @map_win.win.setpos(0, 29-@player.name.length/2)
    @map_win.win.addstr("ConsoleRPG - #{@player.name}")
    @map_win.win.refresh
    @map_win.win.setpos(24,2)

    @messages_win.win.setpos(1, 2)
    @messages_win.win.addstr('> MAP | BAG | EQUIPPED | STATS | SKILLS')
    @messages_win.win.setpos(2, 2)
    @messages_win.win.addstr('--> ')
    @messages_win.win.refresh

    user_menu_input = @messages_win.win.getstr.upcase

    #
    ## MENU > MAP
    #
    if user_menu_input == 'MAP'
      Map.list_all(@map_win)

      @map_win.win.box('j', '~')
      @map_win.win.setpos(0, 29-@player.name.length/2)
      @map_win.win.addstr("ConsoleRPG - #{@player.name}")
      @map_win.win.refresh

      @messages_win.win.setpos(1, 2)
      @messages_win.win.deleteln
      @messages_win.win.deleteln
      @messages_win.win.insertln
      @messages_win.win.insertln
      @messages_win.win.box('j', '~')
      @messages_win.win.setpos(0, 28)
      @messages_win.win.addstr('Input/Message Log')
      @messages_win.win.setpos(1, 2)
      @messages_win.win.addstr('> Enter a map name to load')
      @messages_win.win.setpos(2, 2)
      @messages_win.win.addstr("--> ")
      @messages_win.win.refresh

      # initialize @map
      map_name_input = @messages_win.win.getstr
      @map = @game.load_map(map_name_input)

      # build map in window
      @map_win.build_map(@map)

      @player.set_location(@map.current_map)

      @messages_win.win.setpos(1, 2)
      @messages_win.win.deleteln
      @messages_win.win.deleteln
      @messages_win.win.insertln
      @messages_win.win.insertln
      @messages_win.win.box('j', '~')
      @messages_win.win.setpos(0, 28)
      @messages_win.win.addstr('Input/Message Log')
      @messages_win.win.setpos(1, 2)
      @messages_win.win.addstr("> #{@map.name} loaded successfully, player: #{@player.location}")
      @messages_win.win.refresh

      # get input and move player loop
      while @player.location != []
        @messages_win.win.refresh
        user_movement_input = @map_win.win.getch
        new_player_loc = @map.new_player_loc_from_input(@player, user_movement_input)

        unless @player.location == []
          @messages_win.win.setpos(2, 2)
          message = @map.move_player(player: @player, new_player_loc: new_player_loc) { |msg| @messages_win.win.addstr(msg) }
          @messages_win.win.deleteln
          @messages_win.win.insertln
          @messages_win.win.box('j', '~')
          @messages_win.win.setpos(2, 2)
          @messages_win.win.addstr(message)
          @messages_win.win.refresh

          indexed_map = @map.current_map.each_with_index.map{ |line, i| [line, i] }

          indexed_map.each do |line, i|
            @map_win.win.setpos(i + 1, 2)
            line_ary = line.split('')
            line_ary.each do |c|
              @map_win.win.attron(Curses.color_pair(map_colors_hash(c))) { @map_win.win.addch(c) }
            end
          end

          @map_win.win.setpos(24,2)
        end
      end

      # @map_win.win.close
      # Curses.refresh

    #
    ## MENU > BAG
    #
    elsif user_menu_input == 'BAG'
      @player.inventory.list

      puts "\nEnter a command and an item number seperated by a space (Ex. #{'\'EQUIP 2\''.colorize(93)}, #{'\'use 5\''.colorize(93)}, #{'\'Drop 11\''.colorize(93)})."
      print '-->'

      user_bag_input = gets.chomp.upcase.split(' ')
      command    = user_bag_input[0]
      item_num   = user_bag_input[1].to_i

      @player.inventory.interact_with_item(command, item_num)

    #
    ## MENU > EQUIPPED
    #
    elsif user_menu_input == 'EQUIPPED'
      @player.equipped.list

    #
    ## MENU > STATS
    #
    elsif user_menu_input == 'STATS'
      @player.show_stats

    #
    ## MENU > SKILLS
    #
    elsif user_menu_input == 'SKILLS'
      @player.show_skills

    # Menu input error
    else
      puts 'Error, command not recognized.'.colorize(101)
    end
  ensure
    Curses.close_screen
  end
end
