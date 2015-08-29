# handles equipping, dropping, using an item in a players inventory
class InventoryInteractor
  attr_accessor :id, :player, :equipped, :inventory, :command, :item, :item_num

  #
  ## INSTANCE METHODS
  #

  def initialize(player, command, item_num)
    @id        = object_id
    @player    = player
    @equipped  = player.equipped
    @inventory = player.inventory
    @command   = command
    @item      = inventory.find_item(item_num)
    @item_num  = item_num
  end

  def execute
    method_name = "command_#{command}".to_sym
    messages = send(method_name, item_num)
    inventory.refresh_indexes
    $message_log.show_msgs(messages)
  end

  def equip_is_confirmed?
    unless equipped_item.nil?
      prompt_equipment_replace
      return confirm_equip?
    end
    true
  end

  private

  def command_equip(item_num)
    equipped.send("#{item.type}=", item)
    player.update_stats
    messages = command_drop(item_num)
    messages << Message.new("> #{item.name} equipped.", 'green')
    messages
  end

  def command_drop(item_num)
    inventory.items.slice!(item_num - 1)
    messages = [Message.new("> #{item.name} removed from bag", 'green')]
    messages
  end

  def prompt_equipment_replace
    if equipped_item.type == 'weapon'
      messages = [Message.new("> Replace #{equipped_item.type}(damage: #{equipped_item.attributes[:damage]}, speed: #{equipped_item.attributes[:speed]})? [Y/N]", 'yellow')]
    else
      messages = [Message.new("> Replace #{equipped_item.type}(armor: #{equipped_item.attributes[:armor]})? [Y/N]", 'yellow')]
    end
    messages << Message.new('--> ', 'normal')

    $message_log.show_msgs(messages)
  end

  def confirm_equip?
    loop do
      user_input = $message_win.win.getch.upcase
      $message_log.append(user_input)

      if user_input == 'Y'
        inventory.items << equipped_item
        return true
      elsif user_input == 'N'
        messages = [Message.new('> You got it boss.', 'green')]
        $message_log.show_msgs(messages)
        return false
      else
        messages = [Message.new('> Must enter \'Y\' or \'N\'', 'red'), Message.new('--> ', 'normal')]
        $message_log.show_msgs(messages)
      end
    end
  end

  def equipped_item
    player.equipped.send(item.type)
  end
end
