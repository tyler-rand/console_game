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
  def interact(command, item_num)
    messages = []
    item = nil
    items.each { |x, i| item = x if item_num == i }

    case command
    when 'EQUIP'
      equipped_item = player.equipped.send(item.type)

      if equipped_item.nil?
        equip(item, item_num)
        messages << ["> #{item.name} equipped.", 'green']

      else # query user to replace equipped item
        state = 0
        while state == 0
          if equipped_item.type == 'weapon'
            messages << ["> Replace #{equipped_item.type}(damage: #{equipped_item.attributes[:damage]}, speed: #{equipped_item.attributes[:speed]})? [Y/N]", 'yellow']
          else
            messages << ["> Replace #{equipped_item.type}(armor: #{equipped_item.attributes[:armor]})? [Y/N]", 'yellow']
          end
          messages << ['--> ', 'normal']

          show_msgs(messages)

          user_input = $messages_win.win.getch.upcase
          $message_log.log[-1][0] += user_input

          if user_input == 'Y'
            self.items << equipped_item
            equip(item, item_num)
            messages = [["> #{item.name} equipped.", 'green']]
            state = 1
          elsif user_input == 'N'
            messages = [['> You got it boss.', 'green']]
            state = 1
          else
            messages = [['> Must enter \'Y\' or \'N\'', 'red']]
          end
        end
      end

    when 'USE'
      use(item)
    when 'DROP'
      remove(item_num)
    else
      messages << ['> Error, command not recognized.', 'red']
    end

    refresh_inventory_indexes
    player.save
    messages
  end

  def equip(item, item_num)
    player.equipped.send("#{item.type}=", item)
    remove(item_num)
    player.update_stats
  end

  def use_item(item_num)
  end

  def remove(item_num)
    items.slice!(item_num - 1)
  end

  # def confirm_equip(item_num)
  #   equipped_item.nil? ? equip(item, item_num) : query_equip(item)
  # end

  def refresh_inventory_indexes
    self.items = items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
  end
end
