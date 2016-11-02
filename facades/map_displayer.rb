# displays and scrolls map in main window
class MapDisplayer
  attr_accessor :map, :win, :cur_x_range, :cur_y_range

  MAP_HEIGHT = 19
  MAP_WIDTH = 20
  TOP_BEZEL = 2
  LEFT_BEZEL = 5

  def initialize(map, win)
    @map = map
    @win = win
    @cur_x_range = nil
    @cur_y_range = nil

    new_display_ranges
  end

  def display_colored_map
    indexed_map = map.current_map[cur_y_range].each_with_index.map do |line, i|
      [line[cur_x_range], i]
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
    update_display(old_player_loc)
    update_display(new_player_loc)
  end

  private

  def new_display_ranges
    self.cur_x_range, self.cur_y_range = MapDisplayRangeFinder.new(map).display_ranges
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
      Vendor::MAP_ICON => Curses::COLOR_YELLOW, Mob::NAMED_MAP_ICON => Curses::COLOR_MAGENTA
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
