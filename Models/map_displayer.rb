# displays and scrolls map in main window
class MapDisplayer
  attr_accessor :map, :win, :cur_x_range, :cur_y_range, :max_x, :max_y

  def initialize(map, win)
    @map = map
    @win = win
    @cur_x_range = nil
    @cur_y_range = nil
    @max_x = map.current_map[0].size
    @max_y = map.current_map.size
  end

  def display_colored_map
    new_display_ranges

    indexed_map = map.current_map[cur_y_range].each_with_index.map { |line, i| [line[cur_x_range], i] }

    indexed_map.each do |line, i|
      print_map_line(line, i)
    end
  end

  private

  def new_display_ranges
    player_loc = map.find_player

    find_x_range(player_loc)
    find_y_range(player_loc)
  end

  def find_x_range(player_loc)
    left_pos = player_loc[1] - 9
    right_pos = player_loc[1] + 9

    self.cur_x_range = if left_pos < 1 # on left edge
                         (0..20)
                       elsif right_pos > max_x # on right edge
                         (max_x - 20..max_x)
                       else # not on left or right edge
                         (player_loc[1] - 10..player_loc[1] + 10)
                       end
  end

  def find_y_range(player_loc)
    top_pos = player_loc[0] - 10
    bot_pos = player_loc[0] + 10

    self.cur_y_range = if top_pos < 1 # on top edge
                         (0..19)
                       elsif bot_pos > max_y # on bottom edge
                         (max_y - 19..max_y)
                       else # not on top or bottom edge
                         (player_loc[0] - 9..player_loc[0] + 9)
                       end
  end

  def print_map_line(line, index)
    win.setpos(index + 1, 2)
    line.split('').each { |c| win.attron(Curses.color_pair(map_colors[c])) { win.addch(c) } }
  end

  def map_colors
    {
      '.' => Curses::COLOR_GREEN, 'P' => Curses::COLOR_BLUE, '$' => Curses::COLOR_WHITE,
      'x' => Curses::COLOR_RED, 'c' => Curses::COLOR_YELLOW, 'm' => Curses::COLOR_MAGENTA,
      'o' => Curses::A_NORMAL, '_' => Curses::A_NORMAL, 'Q' => Curses::A_NORMAL,
      'W' => Curses::A_NORMAL, 'A' => Curses::A_NORMAL
    }
  end
end
