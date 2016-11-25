require 'curses'
require 'io/console'
require 'YAML'

FOLDERS_TO_REQUIRE = %w(facades helpers models ruby_classes windows).freeze
FOLDERS_TO_REQUIRE.each do |folder|
  Dir[File.join(__dir__, folder, '*.rb')].each { |file| require file }
end

################
### RUN GAME ###
################

binding.pry
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
@main_win, $message_win, $right_win, @action_win = screen.build_display

begin
  loop do
    @main_win.refresh_display(title: @player.name)
    $right_win.build_display(@player)

    user_menu_input = main_menu_query

    case user_menu_input
    when 'MAP'
      MapMenu.new(@action_win, @main_win, @player).menu
    when 'BAG'
      bag_menu
    when 'EQUIPPED'
      equipped_menu
    when 'STATS'
      stats_menu
    when 'SKILLS'
      skills_menu
    when 'EXIT'
      exit
    else
      $message_win.display_messages(Message.new('> Error, command not recognized.', 'red'))
    end
  end
ensure
  Curses.close_screen
end
