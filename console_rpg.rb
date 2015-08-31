require 'curses'
require 'io/console'
require 'YAML'

# load models and helpers
Dir[File.join(__dir__, 'Models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'Helpers', '*.rb')].each { |file| require file }

################
### RUN GAME ###
################

puts 'Shit, its ConsoleRPG. v0.0.1'.colorize(44)

loop do
  puts "\nEnter #{'NEW'.colorize(93)} for a new game, #{'LOAD'.colorize(93)} to resume progress"\
       " or #{'RULES'.colorize(93)} to learn how to play."
  print '-->'

  user_initialize_input = gets.chomp.upcase

  ## NEW PLAYER
  if user_initialize_input == 'NEW'
    @player = Player.prompt_and_create

  ## LOAD PLAYER
  elsif user_initialize_input == 'LOAD'
    @player = Player.load

  ## RULES
  elsif user_initialize_input == 'RULES'
    Game.show_rules

  ## ADMIN
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
    @main_win.refresh_display(title: @player.name)
    @right_win.build_display(@player)

    user_menu_input = main_menu_query

    ## MENU > MAP
    if user_menu_input == 'MAP'
      map_menu

    ## MENU > BAG
    elsif user_menu_input == 'BAG'
      bag_menu

    ## MENU > EQUIPPED
    elsif user_menu_input == 'EQUIPPED'
      equipped_menu

    ## MENU > STATS
    elsif user_menu_input == 'STATS'
      stats_menu

    ## MENU > SKILLS
    elsif user_menu_input == 'SKILLS'
      skills_menu

    # Menu input error
    else
      messages = [Message.new('> Error, command not recognized.', 'red')]
      $message_log.show_msgs(messages)
    end
  end
ensure
  Curses.close_screen
end
