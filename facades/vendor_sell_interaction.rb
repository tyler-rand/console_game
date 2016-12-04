# vendor interaction in the sell menu
class VendorSellInteraction
  def self.execute(win, player)
    @win = win
    @player = player

    sell_menu
  end

  # private class methods

  def self.sell_menu
    @win.refresh_display { @player.inventory.display(@win) }

    item_index = sell_prompt
    return VendorInteractor.close_vendor if item_index == 'back'

    verify_sell(item_index.to_i)
  end

  def self.sell_prompt
    msgs = [Message.new('> Enter an item number to sell, or \'BACK\'.', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.verify_sell(item_index)
    item = @player.inventory.find_item(item_index)

    if item.nil?
      VendorInteractor.command_not_recognized
      return sell_menu
    end

    input = prompt_confirm_sell(item)
    sell_action(input, item, item_index)
  end

  def self.prompt_confirm_sell(item)
    msgs = [
      Message.new("> Really sell #{item.name} for #{item.value}? (Y/N)", 'yellow'),
      Message.new('--> ', 'normal')
    ]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.sell_action(input, item, item_index)
    case input
    when 'yes', 'y' then sell_item(item, item_index)
    when 'no', 'n' then sell_menu
    else
      VendorInteractor.command_not_recognized
      verify_sell(item_index)
    end
  end

  def self.sell_item(item, item_index)
    @player.inventory.money += item.value
    interaction = InventoryInteractor.new(@player, 'drop', item_index)
    interaction.execute

    msgs = [Message.new("#{item.name} sold!", 'normal'),
            Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  private_class_method :sell_menu, :sell_prompt, :verify_sell, :prompt_confirm_sell, :sell_action,
                       :sell_item
end
