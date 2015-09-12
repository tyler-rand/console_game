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
    send(method_name, item_num)
  end

  private

  def command_equip(item_num)
    return unless equip_confirmed?
    equipped.send("#{item.type}=", item)
    command_drop(item_num)
    player.update_stats
    msgs = [Message.new("> #{item.name} equipped.", 'green')]
    $message_win.display_messages(msgs)
  end

  def equip_confirmed?
    unless equipped_item.nil?
      prompt_equipment_replace
      return confirm_equip?
    end
    true
  end

  def command_drop(item_num)
    inventory.items.slice!(item_num - 1)
    inventory.refresh_indexes
    msgs = [Message.new("> #{item.name} removed from bag", 'green')]
    $message_win.display_messages(msgs)
  end

  def prompt_equipment_replace
    if equipped_item.type == 'weapon'
      wep_replace_msg
    else
      armor_replace_msg
    end
  end

  def wep_replace_msg
    msgs = [Message.new("> Replace #{equipped_item.type}(damage: #{equipped_item.damage}, "\
                        "speed: #{equipped_item.speed})? [Y/N]", 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def armor_replace_msg
    msgs = [Message.new("> Replace #{equipped_item.type}(armor: #{equipped_item.armor})? "\
                        '[Y/N]', 'yellow'), Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def confirm_equip?
    loop do
      user_input = equip_replace_input

      if user_input == 'Y'
        return confirm_replace_item(user_input)
      elsif user_input == 'N'
        return dont_replace_item(user_input)
      else
        equip_confirm_error
      end
    end
  end

  def equipped_item
    player.equipped.send(item.type)
  end

  def equip_replace_input
    input = $message_win.win.getch
    input.upcase! if equip_input_valid?(input)
  end

  def equip_input_valid?(input)
    %w(y n).include?(input)
  end

  def confirm_replace_item(input)
    $message_win.message_log.append(input)
    inventory.items << equipped_item
    true
  end

  def dont_replace_item(input)
    $message_win.message_log.append(input)
    msgs = [Message.new('> You got it boss.', 'green')]
    $message_win.display_messages(msgs)
    false
  end

  def equip_confirm_error
    msgs = [Message.new('> Must enter \'Y\' or \'N\'', 'red'), Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)
  end
end
