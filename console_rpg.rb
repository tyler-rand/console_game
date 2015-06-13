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

  user_input = gets.chomp.upcase

  #
  ## NEW PLAYER
  #
  if user_input == 'NEW'
    @player = @game.new_player

  #
  ## LOAD PLAYER
  #
  elsif user_input == 'LOAD'
    @player = @game.load_player

  #
  ## RULES
  #
  elsif user_input == 'RULES'
    Game.show_rules

  #
  ## ADMIN
  #
  elsif user_input == 'ADMIN77'
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
  l = '|'.colorize(2)

  puts "\n#{@player.name}'s Character Menu Screen"
  puts "#{'MAP'.colorize(93)} #{l} #{'BAG'.colorize(93)} #{l} #{'EQUIPPED'.colorize(93)} #{l} #{'STATS'.colorize(93)} #{l} #{'SKILLS'.colorize(93)}"
  print '-->'

  user_input = gets.chomp.upcase

  #
  ## MENU > MAP
  #
  if user_input == 'MAP'
    @map = @game.load_map
    @player.set_location(@map.current_map)

    Curses.noecho
    Curses.init_screen
    Curses.start_color

    begin
      Curses.crmode
      Curses.init_pair(Curses::COLOR_GREEN, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_WHITE, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_YELLOW, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
      Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_RED, Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_BLACK, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_CYAN, Curses::COLOR_WHITE, Curses::COLOR_RED)

      map_win = Curses::Window.new(26, 70, 0, 0)
      map_win.setpos(1, 3)
      map_win.addstr("Map - #{@map.name}")
      map_win.setpos(22, 3)
      map_win.addstr("WASD to move, C to exit")
      map_win.setpos(23, 3)
      map_win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')
      map_win.refresh

      messages_win = Curses::Window.new(7, 70, 26, 0)
      messages_win.box('|', '-')
      messages_win.setpos(1, 3)
      messages_win.addstr('Messages')
      messages_win.setpos(2, 3)
      messages_win.refresh

      third_win = Curses::Window.new(33, 30, 0, 70)
      third_win.box('|', '-')
      third_win.setpos(1, 3)
      third_win.addstr('Stats/Equipped')
      third_win.setpos(3, 3)
      third_win.refresh

      map_with_index = @map.current_map.each_with_index.map{ |line,i| [line, i] }

      map_with_index.each do |line, i|
        map_win.setpos(i + 3, 3)
        map_win.addstr("#{line}\n")
      end

      map_win.box('|', '-')
      map_win.setpos(20, 3)

      # get input and move player loop
      while @player.location != []
        messages_win.refresh
        user_input     = map_win.getch
        new_player_loc = @map.new_player_loc_from_input(@player, user_input)

        unless @player.location == []
          message = @map.move_player(player: @player, new_player_loc: new_player_loc)
          messages_win.deleteln
          messages_win.insertln
          messages_win.box('|', '-')
          messages_win.setpos(2, 3)
          messages_win.addstr(message)
          messages_win.refresh

          map_with_index = @map.current_map.each_with_index.map{ |line, i| [line, i] }

          map_with_index.each do |line, i|
            map_win.setpos(i + 3, 3)
            line_ary = line.split('')
            line_ary.each do |c|
              map_win.attron(Curses.color_pair(map_colors_hash(c))) { map_win.addch(c) }
            end
          end

          map_win.setpos(20,3)
        end
      end

      map_win.close
      Curses.refresh
    ensure
      Curses.close_screen
    end

  #
  ## MENU > BAG
  #
  elsif user_input == 'BAG'
    @player.inventory.list

    puts "\nEnter a command and an item number seperated by a space (Ex. #{'\'EQUIP 2\''.colorize(93)}, #{'\'use 5\''.colorize(93)}, #{'\'Drop 11\''.colorize(93)})."
    print '-->'

    user_input = gets.chomp.upcase.split(' ')
    command    = user_input[0]
    item_num   = user_input[1].to_i

    @player.inventory.interact_with_item(command, item_num)

  #
  ## MENU > EQUIPPED
  #
  elsif user_input == 'EQUIPPED'
    @player.equipped.list

  #
  ## MENU > STATS
  #
  elsif user_input == 'STATS'
    @player.show_stats

  #
  ## MENU > SKILLS
  #
  elsif user_input == 'SKILLS'
    @player.show_skills

  # Menu input error
  else
    puts 'Error, command not recognized.'.colorize(101)
  end
end
