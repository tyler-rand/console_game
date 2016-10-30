def bag_menu
  @action_win.refresh_display { @player.inventory.list(@action_win) }

  command, item_num = prompt_user_bag_input

  if bag_input_validated?(command, item_num)
    execute_command(command, item_num)
  else
    bag_command_error
  end

  @action_win.refresh_display
end

def prompt_user_bag_input
  user_bag_input = prompt_bag_command
  command        = user_bag_input[0].downcase unless user_bag_input == []
  item_num       = user_bag_input[1].to_i

  return command, item_num
end

def prompt_bag_command
  msgs = [Message.new('> Enter a command and number seperated by a space (Ex. Equip 2)', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)
  user_bag_input = $message_win.win.getstr.split
  $message_win.message_log.append(user_bag_input.join(' '))

  user_bag_input
end

def bag_input_validated?(command, item_num)
  bag_command_valid?(command) && item_num_valid?(item_num)
end

def bag_command_valid?(command)
  %w(equip use inspect drop).include?(command)
end

def item_num_valid?(item_num)
  (1..@player.inventory.items.size).include?(item_num)
end

def bag_command_error
  $message_win.display_messages(Message.new('> Bag command error.', 'red'))
end

def execute_command(command, item_num)
  InventoryInteractor.new(@player, command, item_num).execute
end
