# displays and scrolls map in main window
class MapDisplayer
  attr_accessor :map, :win, :cur_x_range, :cur_y_range, :max_x, :max_y

  MAP_HEIGHT = 19
  MAP_WIDTH = 20
  TOP_BEZEL = 2
  LEFT_BEZEL = 5

  def initialize(map, win)
    @map = map
    @win = win
    @cur_x_range = nil
    @cur_y_range = nil
    @max_x = map.current_map[0].size - 1
    @max_y = map.current_map.size - 1

    new_display_ranges
  end

  def display_colored_map
    indexed_map = map.current_map[cur_y_range].each_with_index.map do
      |line, i| [line[cur_x_range], i]
    end

    indexed_map.each do |line, i|
      print_map_line(line, i)
    end
  end

  def update_player_location(new_player_loc, old_player_loc)
    # refresh whole map if it needs to scroll
    # TODO: try instead writing each char, checking which are same and only writing the changes to
    # see if its faster / doesnt give the screen blinking
    return display_colored_map if scroll_map?

    # only change 2 locations if map doesnt need to scroll
    new_display_ranges
    update_display(old_player_loc)
    update_display(new_player_loc)
  end

  private

  def new_display_ranges
    player_loc = map.find_player

    find_x_range(player_loc)
    find_y_range(player_loc)
  end

  def find_x_range(player_loc)
    left_from_edge = player_loc[1] - 9
    right_from_edge = player_loc[1] + 9

    self.cur_x_range = x_range(left_from_edge, right_from_edge)
  end

  def x_range(left_from_edge, right_from_edge)
    if left_from_edge < 1 # on left edge
      (0..19)
    elsif right_from_edge >= max_x # on right edge
      (max_x - 19..max_x)
    else # not on left or right edge
      (left_from_edge..right_from_edge + 1)
    end
  end

  def find_y_range(player_loc)
    top_from_edge = player_loc[0] - 10
    bot_from_edge = player_loc[0] + 10

    self.cur_y_range = y_range(top_from_edge, bot_from_edge)
  end

  def y_range(top_from_edge, bot_from_edge)
    if top_from_edge < 0 # on top edge
      (0..18)
    elsif bot_from_edge > max_y # on bottom edge
      (max_y - 18..max_y)
    else # not on top or bottom edge
      (top_from_edge + 1..bot_from_edge - 1)
    end
  end

  def print_map_line(line, index)
    win.setpos(index + 2, 5)
    line.split('').each { |c| win.attron(Curses.color_pair(map_colors[c])) { win.addch(c) } }
  end

  def map_colors
    {
      '.' => Curses::COLOR_GREEN, Player::MAP_ICON => Curses::COLOR_BLUE,
      '$' => Curses::COLOR_WHITE, 'x' => Curses::COLOR_RED, 'c' => Curses::COLOR_YELLOW,
      Mob::MAP_ICON => Curses::COLOR_MAGENTA, 'o' => Curses::A_NORMAL, '_' => Curses::A_NORMAL,
      Quest::MAP_ICON => Curses::COLOR_YELLOW, 'W' => Curses::A_NORMAL, 'A' => Curses::A_NORMAL,
      '^' => Curses::COLOR_GREEN, 'v' => Curses::COLOR_GREEN,
      Vendor::MAP_ICON => Curses::COLOR_YELLOW
    }
  end

  def scroll_map?
    y = cur_y_range
    x = cur_x_range

    new_display_ranges

    true unless cur_y_range == y && cur_x_range == x
  end

  def update_display(map_loc)
    @map_loc = map_loc

    win.setpos(window_row, window_column)
    win.attron(Curses.color_pair(map_colors[map_char])) { win.addch(map_char) }
  end

  def window_row
    y_difference = 1 + cur_y_range.last(1)[0] - @map_loc[0]

    MAP_HEIGHT + TOP_BEZEL - y_difference
  end

  def window_column
    x_difference = 1 + cur_x_range.last(1)[0] - @map_loc[1]

    MAP_WIDTH + LEFT_BEZEL - x_difference
  end

  def map_char
    map.current_map[@map_loc[0]][@map_loc[1]]
  end
end
