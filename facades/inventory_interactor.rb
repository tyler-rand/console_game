# handles equipping, dropping, using an item in a players inventory
class InventoryInteractor
  attr_accessor :player, :equipped, :inventory, :command, :item, :item_num

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
    send(method_name)
  end

  private

  def command_equip
    return unless equip_confirmed?

    equip_item
    equip_update_displays
  end

  def equip_update_displays
    $message_win.display_messages(Message.new("> #{item.name} equipped.", 'green'))
    $right_win.build_display(player)
  end

  def equip_confirmed?
    if equipped_item
      prompt_equipment_replace
      return confirm_equip?
    end
    true
  end

  # not implemented yet... use case is adding specific items, unlike chest which rolls random ones
  # def command_add
  #   index = inventory.items.length + 1
  #   inventory.items << [item, index]
  #   msgs = [Message.new("> #{item.name} added to bag", 'green')]
  #   $message_win.display_messages(msgs)
  # end

  def command_drop
    inventory.items.slice!(item_num - 1)
    inventory.refresh_indexes
    item_removed_msg
  end

  def item_removed_msg
    $message_win.display_messages(Message.new("> #{item.name} removed from bag", 'green'))
  end

  def prompt_equipment_replace
    equipped_item.type == 'weapon' ? wep_replace_msg : armor_replace_msg
  end

  def wep_replace_msg
    msgs = [Message.new("> Replace #{equipped_item.type}(damage: #{equipped_item.damage}, "\
                        "speed: #{equipped_item.speed})? (Y/N)", 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def armor_replace_msg
    msgs = [Message.new("> Replace #{equipped_item.type}(defense: #{equipped_item.defense})? "\
                        '(Y/N)', 'yellow'), Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def confirm_equip?
    loop do
      input = equip_replace_input
      $message_win.message_log.append(input)

      case input
      when 'Y'
        return confirm_replace_item
      when 'N'
        return dont_replace_item
      else
        equip_confirm_error
      end
    end
  end

  def equip_item
    equipped.send("#{item.type}=", item)
    command_drop
    player.update_stats
  end

  def equipped_item
    equipped.send(item.type)
  end

  def equip_replace_input
    input = $message_win.win.getch
    input.upcase! if %w(y n).include?(input)
    input
  end

  def confirm_replace_item
    inventory.items << equipped_item
    true
  end

  def dont_replace_item
    $message_win.display_messages(Message.new('> You got it boss.', 'green'))
    false
  end

  def equip_confirm_error
    msgs = [Message.new('> Must enter \'Y\' or \'N\'', 'red'), Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end
end
