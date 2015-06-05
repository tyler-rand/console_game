# Application helper methods

def find_player_loc(current_map)
  player_loc = nil

  current_map.map do |line| 
    player_loc = [current_map.index(line), line.index('P')] if line.include?('P')
  end

  player_loc
end

def find_new_player_loc(user_input, player_loc, current_map)
  case user_input
  when 'w' # move up 1
    new_player_loc = [player_loc[0] - 1, player_loc[1]]
  when 'a' # move left 1
    new_player_loc = [player_loc[0], player_loc[1] - 1]
  when 's' # move down 1
    new_player_loc = [player_loc[0] + 1, player_loc[1]]
  when 'd' # move right 1
    new_player_loc = [player_loc[0], player_loc[1] + 1]
  end
  
  new_player_loc
end

def colorize_item_name(item)
  case item.quality
  when 'Shitty'
    n = 90
  when 'Normal'
    n = 3
  when 'Magic'
    n = 92
  when 'Rare'
    n = 93
  when 'Unique'
    n = 94
  when 'Legendary'
    n = 91
  end

  item.name.colorize(n)
end

# THIS BELONGS ELSEWHERE
def levels_exp(level)
  levels_with_exp = {
    1 => 10,
    2 => 20,
    3 => 30,
    4 => 40,
    5 => 50
  }
  levels_with_exp[level]
end
