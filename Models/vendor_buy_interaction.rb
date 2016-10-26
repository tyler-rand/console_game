class VendorBuyInteraction
  def self.perform(win, player, vendor)
    @win = win
    @player = player
    @vendor = vendor

    buy_menu
  end

  # private class methods

  def self.buy_menu
    @win.refresh_display { @vendor.inventory.list(@win) }

    item_index = buy_prompt
    return VendorInteractor.close_vendor if item_index == 'back'
    verify_buy(item_index.to_i)
  end

  def self.buy_prompt
    msgs = [Message.new('> Enter an item number to buy, or \'BACK\'.', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.verify_buy(item_index)
    item = @vendor.inventory.find_item(item_index)
    return VendorInteractor.command_not_recognized { buy_menu } if item.nil?

    input = prompt_confirm_buy(item)
    buy_action(input, item)
  end

  def self.prompt_confirm_buy(item)
    msgs = [Message.new("> Are you sure you want to buy #{item.name} for #{(item.value * 1.2).floor}? (Y/N)", 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.buy_action(input, item)
    case input
    when 'yes', 'y' then buy_item(item)
    when 'no', 'n' then buy_menu
    else
      VendorInteractor.command_not_recognized { verify_buy(item) }
    end
  end

  def self.buy_item(item)
    item_cost = (item.value * 1.2).floor
    return buy_menu if item_too_expensive?(item_cost)

    @player.inventory.money -= item_cost
    InventoryInteractor.new(@player, 'add', item).execute

    msgs = [Message.new("#{item.name} bought!", 'normal'), Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def self.item_too_expensive?(item_cost)
    return false unless item_cost > @player.inventory.money

    msgs = [Message.new('> Not enough money.', 'red')]
    $message_win.display_messages(msgs)

    true
  end

  private_class_method :buy_menu, :buy_prompt, :verify_buy, :prompt_confirm_buy, :buy_action,
                       :buy_item, :item_too_expensive?
end
