# handles finding and setting the cur_x_range / cur_y_range of the MapDisplayer
class MapDisplayRangeFinder
  attr_accessor :map, :max_x, :max_y

  def initialize(map)
    @map = map
    @max_x = map.current_map[0].size - 1
    @max_y = map.current_map.size - 1
  end

  def display_ranges
    player_loc = map.find_player

    [find_x_range(player_loc), find_y_range(player_loc)]
  end

  private

  def find_x_range(player_loc)
    left_from_edge = player_loc[1] - 9
    right_from_edge = player_loc[1] + 9

    x_range(left_from_edge, right_from_edge)
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

    y_range(top_from_edge, bot_from_edge)
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
end
