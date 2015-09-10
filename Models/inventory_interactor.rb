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
    inventory.refresh_indexes
  end

  private

  def command_equip(item_num)
    return unless equip_confirmed?
    equipped.send("#{item.type}=", item)
    player.update_stats
    command_drop(item_num)
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
    msgs = [Message.new("> #{item.name} removed from bag", 'green')]
    $message_win.display_messages(msgs)
  end

  def prompt_equipment_replace
    if equipped_item.type == 'weapon'
      msgs = [Message.new("> Replace #{equipped_item.type}(damage: #{equipped_item.damage}, "\
                          "speed: #{equipped_item.speed})? [Y/N]", 'yellow')]
    else
      msgs = [Message.new("> Replace #{equipped_item.type}(armor: #{equipped_item.armor})?"\
                          ' [Y/N]', 'yellow')]
    end
    msgs << Message.new('--> ', 'normal')

    $message_win.display_messages(msgs)
  end

  def confirm_equip?
    loop do
      user_input = $message_win.win.getch
      user_input.upcase! if equip_input_valid?(user_input)

      if user_input == 'Y'
        $message_win.message_log.append(user_input)
        inventory.items << equipped_item
        return true
      elsif user_input == 'N'
        $message_win.message_log.append(user_input)
        msgs = [Message.new('> You got it boss.', 'green')]
        $message_win.display_messages(msgs)
        return false
      else
        msgs = [Message.new('> Must enter \'Y\' or \'N\'', 'red'), Message.new('--> ', 'normal')]
        $message_win.display_messages(msgs)
      end
    end
  end

  def equipped_item
    player.equipped.send(item.type)
  end

  def equip_input_valid?(input)
    %w(y n).include?(input)
  end
end
