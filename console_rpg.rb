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

################
### RUN GAME ###
################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

@game = Game.new # Game initialized, no player loaded

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
    @messages_win.win.clear
    @messages_win.box_with_title

    @main_win.win.clear
    @main_win.win.box('j', '~')
    @main_win.win.setpos(0, 29-@player.name.length/2)
    @main_win.win.addstr("ConsoleRPG - #{@player.name}")
    @main_win.win.refresh

    @right_win.build_display(@player)
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['', @game.message_log.log.length]
    @game.message_log.log << ['> MAP | BAG | EQUIPPED | STATS | SKILLS', @game.message_log.log.length]
    @game.message_log.log << ['--> ', @game.message_log.log.length]
    @game.message_log.scroll(9)

    line_num = 1
    @game.message_log.display_range.each do |line|
      @messages_win.win.setpos(line_num, 2)
      @messages_win.win.addstr(@game.message_log.log[line][0])
      line_num += 1
    end

    @messages_win.win.refresh

    user_menu_input = @messages_win.win.getstr.upcase
    @game.message_log.log[-1][0] += user_menu_input

    #
    ## MENU > MAP
    #
    if user_menu_input == 'MAP'
      Map.list_all(@main_win)

      @main_win.win.box('j', '~')
      @main_win.win.setpos(0, 29-@player.name.length/2)
      @main_win.win.addstr("ConsoleRPG - #{@player.name}")
      @main_win.win.refresh

      @game.message_log.log << ['> Enter a map name to load', @game.message_log.log.length]
      @game.message_log.log << ['--> ', @game.message_log.log.length]
      @game.message_log.scroll(2)
      @messages_win.win.clear

      line_num = 1
      @game.message_log.display_range.each do |line|
        @messages_win.win.setpos(line_num, 2)
        @messages_win.win.addstr(@game.message_log.log[line][0])
        line_num += 1
      end

      @messages_win.box_with_title
      @messages_win.win.setpos(line_num - 1, 6)
      @messages_win.win.refresh

      map_name_input = @messages_win.win.getstr
      @game.message_log.log[-1][0] += map_name_input

      # initialize map
      @map = @game.load_map(map_name_input)
      @player.set_location(@map.current_map)

      # build map in window
      @main_win.build_map(@map)
      @main_win.win.setpos(24, 2)

      @game.message_log.log << ["> #{@map.name} loaded successfully, player: #{@player.location}", @game.message_log.log.length]
      @game.message_log.scroll(1)
      @messages_win.win.clear

      line_num = 1
      @game.message_log.display_range.each do |line|
        @messages_win.win.setpos(line_num, 2)
        @messages_win.win.addstr(@game.message_log.log[line][0])
        line_num += 1
      end

      @messages_win.box_with_title
      @messages_win.win.setpos(line_num - 1, 6)
      @messages_win.win.refresh

      # get input and move player loop
      while @player.location != []
        @messages_win.win.refresh
        Curses.noecho
        Curses.curs_set(0)
        user_movement_input = @main_win.win.getch
        Curses.curs_set(1)
        Curses.echo

        new_player_loc = @map.new_player_loc_from_input(@player, user_movement_input)

        unless @player.location == []
          @messages_win.win.setpos(2, 2)
          message = @map.move_player(player: @player, new_player_loc: new_player_loc)

          unless message.nil?
            @game.message_log.log << [message, @game.message_log.log.length]
            @game.message_log.scroll(1)
            @messages_win.win.clear
          end

          line_num = 1
          @game.message_log.display_range.each do |line|
            @messages_win.win.setpos(line_num, 2)
            @messages_win.win.addstr(@game.message_log.log[line][0])
            line_num += 1
          end

          @messages_win.box_with_title
          @messages_win.win.refresh

          indexed_map = @map.current_map.each_with_index.map{ |line, i| [line, i] }

          indexed_map.each do |line, i|
            @main_win.win.setpos(i + 1, 2)
            line_ary = line.split('')
            line_ary.each do |c|
              @main_win.win.attron(Curses.color_pair(map_colors_hash(c))) { @main_win.win.addch(c) }
            end
          end

          @main_win.win.setpos(24, 2)
        end
      end

    #
    ## MENU > BAG
    #
    elsif user_menu_input == 'BAG'
      @player.inventory.list(@main_win)

      @game.message_log.log << ['> Enter a command and number seperated by a space (Ex. Equip 2)', @game.message_log.log.length]
      @game.message_log.log << ['--> ', @game.message_log.log.length]
      @game.message_log.scroll(2)
      @messages_win.win.clear

      line_num = 1
      @game.message_log.display_range.each do |line|
        @messages_win.win.setpos(line_num, 2)
        @messages_win.win.addstr(@game.message_log.log[line][0])
        line_num += 1
      end

      @messages_win.box_with_title
      @messages_win.win.setpos(line_num - 1, 6)
      @messages_win.win.refresh

      user_bag_input = @messages_win.win.getstr
      command    = user_bag_input[0]
      item_num   = user_bag_input[1].to_i

      @player.inventory.interact_with_item(command, item_num)

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
      puts 'Error, command not recognized.'.colorize(101)
    end
  end
ensure
  Curses.close_screen
end
