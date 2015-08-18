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

  def list(window) # list items in inventory
    window.win.setpos(1, 2)
    window.win.addstr("------ #{player.name.upcase}\'S BAG -------")
    window.win.setpos(2, 2)
    window.win.addstr('-------------')
    items.map do |item, i|
      if item.type == 'weapon'
        window.win.setpos(i + 2, 2)
        window.win.addstr("[#{i}] #{item.name} #{item.type}. dmg: #{item.attributes[:damage]}, speed: #{item.attributes[:speed]}")
      else
        window.win.setpos(i + 2, 2)
        window.win.addstr("[#{i}] #{item.name} #{item.type}. armor: #{item.attributes[:armor]}")
      end
    end
    window.win.refresh
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
    messages = []

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
            messages << ["> Replace #{equipped_item.type}(damage: #{equipped_item.attributes[:damage]}, speed: #{equipped_item.attributes[:speed]})? [Y/N]", 'yellow']
          else
            messages << ["> Replace #{equipped_item.type}(armor: #{equipped_item.attributes[:armor]})? [Y/N]", 'yellow']
          end
          messages << ['--> ', 'normal']

          $game.message_log.add_msgs(messages)
          $messages_win.display_messages($game.message_log)

          user_input = $messages_win.win.getch.upcase
          $game.message_log.log[-1][0] += user_input

          # confirm_equip(user_input)
          if user_input == 'Y'
            self.items << equipped_item
            equip_item(item_num)
            messages = [["> #{item.name} equipped.", 'green']]
            state = 1
          elsif user_input == 'N'
            messages = [['> You got it boss.', 'green']]
            state = 1
          else
            messages = [['> Must enter \'Y\' or \'N\'', 'red']]
          end
        end

      else
        equip_item(item_num)
        messages << ["> #{item.name} equipped.", 'green']
      end

    when 'USE'
      use_item(item_num)

    when 'DROP'
      drop_item(item_num)

    else
      messages << ['> Error, command not recognized.', 'red']
    end

    messages
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
