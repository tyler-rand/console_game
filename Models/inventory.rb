# player's inventory, basicslly means player's items
class Inventory
  attr_accessor :id, :player, :items, :money

  #
  ## INSTANCE METHODS
  #

  def initialize(player:)
    @id     = object_id
    @player = player
    @items  = []
    @money  = 0
  end

  def list # list items in inventory
    puts ' -------------'
    puts " --- #{player.name.upcase}'S BAG ----"
    puts ' -------------'
    items.map do |item, i|
      if item.type == 'weapon'
        puts "[#{i}] #{colorize_item_name(item)} #{item.type}. dmg: #{item.attributes[:damage]}, speed: #{item.attributes[:speed]}"
      else
        puts "[#{i}] #{colorize_item_name(item)} #{item.type}. armor: #{item.attributes[:armor]}"
      end
    end
  end

  def add_money(money)
    self.money += money

    puts '--'
    puts "CASH MONEY +#{money}".colorize(33)
    puts '--'

    player.save
  end

  def add_items(map_level)
    index = items.length

    20.times do
      index += 1
      item = Item.roll_new(map_level)
      items << [item, index]
    end

    player.save
  end

  # equip, use, or drop an item in inventory
  def interact_with_item(command, item_num)
    case command
    when 'EQUIP'
      item = nil

      items.map { |x, i| item = x if item_num == i }

      item_type     = item.type
      equipped_item = player.equipped.send(item_type)

      unless equipped_item.nil?
        # query user to replace equipped item
        state = 0

        while state == 0
          if equipped_item.type == 'weapon'
            puts "\nReplace #{equipped_item.type}(damage: #{equipped_item.attributes[:damage]}, speed: #{equipped_item.attributes[:speed]})?? [#{'Y'.colorize(92)}/#{'N'.colorize(91)}]"
          else
            puts "\nReplace #{equipped_item.type}(armor: #{equipped_item.attributes[:armor]})?? [#{'Y'.colorize(92)}/#{'N'.colorize(91)}]"
          end
          print '-->'

          user_input = STDIN.getch.chomp.upcase

          if user_input == 'Y'
            self.items << equipped_item
            equip_item(item_num)
            state = 1
          elsif user_input == 'N'
            puts 'You got it boss.'
            state = 1
          else
            puts 'Enter \'Y\' or \'N\''.colorize(101)
          end
        end

      else
        equip_item(item_num)
      end

    when 'USE'
      use_item(item_num)

    when 'DROP'
      drop_item(item_num)

    else
      puts 'Error, command not recognized.'.colorize(101)
    end

    self
  end

  def equip_item(item_num)
    items.each do |item, i|
      if item_num == i
        player.equipped.send("#{item.type}=", item)

        items.slice!(i - 1)
        refresh_inventory_indexes
        player.update_stats
      end
    end
  end

  def use_item(item_num)
  end

  def drop_item(item_num)
    items.each do |_, i|
      items.slice!(i - 1) if item_num == i
    end

    refresh_inventory_indexes
    player.save
  end

  def refresh_inventory_indexes
    self.items = items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
  end
end
