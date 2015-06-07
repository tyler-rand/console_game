# Application helper methods
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
