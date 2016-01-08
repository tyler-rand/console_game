require 'curses'
require 'io/console'
require 'YAML'

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

  case user_initialize_input
  when 'NEW'
    @player = prompt_player_create
  when 'LOAD'
    @player = load_player
  when 'RULES'
    show_rules
  when 'ADMIN77'
    admin_menu
  else
    puts 'Must enter \'NEW\', \'LOAD\', or \'RULES\'.'.colorize(101)
  end

  break if @player
end

########################################
### GAME STARTED/LOADED, MENU SCREEN ###
########################################

screen = CursesScreen.new
@main_win, $message_win, @right_win = screen.build_display

begin
  loop do
    @main_win.refresh_display(title: @player.name)
    @right_win.build_display(@player)

    user_menu_input = main_menu_query

    case user_menu_input
    when 'MAP'
      map_menu
    when 'BAG'
      bag_menu
    when 'EQUIPPED'
      equipped_menu
    when 'STATS'
      stats_menu
    when 'SKILLS'
      skills_menu
    else
      msgs = [Message.new('> Error, command not recognized.', 'red')]
      $message_win.display_messages(msgs)
    end
  end
ensure
  Curses.close_screen
end
