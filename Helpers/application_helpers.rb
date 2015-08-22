# Application helper methods
def colorize_item_name(item)
  quality_color = {
    'Shitty' => 90, 'Normal' => 3, 'Magic' => 92, 'Rare' => 93, 'Unique' => 94, 'Legendary' => 91
  }

  item.name.colorize(quality_color[item.quality])
end

# THIS BELONGS ELSEWHERE
def level_exp(level)
  level_exp = { 1 => 10, 2 => 20, 3 => 30, 4 => 40, 5 => 50 }
  level_exp[level]
end

def map_colors_hash(char) # does this need to be a method or can the hash just be defined as a var?
  colors_hash = {
    '.' => Curses::COLOR_GREEN, 'P' => Curses::COLOR_BLUE, '$' => Curses::COLOR_WHITE,
    'x' => Curses::COLOR_RED, 'c' => Curses::COLOR_YELLOW, 'm' => Curses::COLOR_MAGENTA,
    'o' => Curses::A_NORMAL, '_' => Curses::A_NORMAL, 'Q' => Curses::A_NORMAL,
    'W' => Curses::A_NORMAL, 'A' => Curses::A_NORMAL
  }
  colors_hash[char]
end

def messages_colors_hash(msg)
  msg_color_hash = {
    'normal' => Curses::A_NORMAL, 'green' => Curses::COLOR_GREEN, 'red' => Curses::COLOR_RED,
    'yellow' => Curses::COLOR_YELLOW
  }
  msg_color_hash.default = Curses::A_NORMAL
  msg_color_hash[msg]
end

def show_msgs(messages)
  $msg_log.add_msgs(messages)
  $messages_win.display_messages($msg_log)
end
