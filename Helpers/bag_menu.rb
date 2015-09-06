def bag_menu
  @main_win.refresh_display(title: @player.name) { @player.inventory.list(@main_win) }

  command, item_num = prompt_user_bag_input

  if bag_input_validated?(command, item_num)
    execute_command(@player, command, item_num)
  else
    bag_command_error
  end

end

def prompt_user_bag_input
  user_bag_input = prompt_bag_command
  command        = user_bag_input[0].downcase
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
  ['equip', 'use', 'inspect', 'drop'].include?(command) ? true : false
end

def item_num_valid?(item_num)
  (1..@player.inventory.items.size).include?(item_num) ? true : false
end

def bag_command_error
  msgs = [Message.new('> Bag command error.', 'red')]
  $message_win.display_messages(msgs)  
end

def execute_command(player, command, item_num)
  interaction = InventoryInteractor.new(@player, command, item_num)
  interaction.execute
end
