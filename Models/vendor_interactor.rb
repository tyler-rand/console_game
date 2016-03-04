class VendorInteractor
  attr_accessor :id, :vendor, :player

  def initialize(player:, vendor:, win:)
    @id     = object_id
    @player = player
    @vendor = vendor
    @win    = win
  end

  def engage
    input = vendor_action_prompt

    if input[0] == 'sell'
      sell_menu
    elsif input[0] == 'buy'
      buy_menu
    else
      vendor_input_error
    end
  end

  private

  def vendor_action_prompt
    msgs = [Message.new('> "What do ya need?"', 'normal'),
            Message.new('> BUY | SELL', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input.split(' ')
  end

  def sell_menu
    @win.refresh_display { @player.inventory.list(@win) }

    item_index = sell_prompt
    return exit_vendor if item_index == 'back'

    verify_sell(item_index.to_i)
  end

  def sell_prompt
    msgs = [Message.new('> Enter an item number to sell, or \'BACK\'.', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def verify_sell(item_index)
    item = @player.inventory.find_item(item_index)
    return not_recognized(:sell_menu) if item.nil?

    input = prompt_confirm_sell(item)
    sell_action(input, item, item_index)
  end

  def prompt_confirm_sell(item)
    msgs = [Message.new("> Are you sure you want to sell #{item.name} for #{item.value}? (Y/N)", 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def sell_action(input, item, item_index)
    return sell_item(item, item_index) if ['y', 'yes'].include?(input)
    return sell_menu if ['n', 'no'].include?(input)
    msgs = [Message.new('> Reply not recognized, try again.', 'red')]
    $message_win.display_messages(msgs)
    verify_sell(item_index)
  end

  def sell_item(item, item_index)
    @player.inventory.money += item.value
    interaction = InventoryInteractor.new(@player, 'drop', item_index)
    interaction.execute

    msgs = [Message.new("#{item.name} sold!", 'normal'),
            Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def buy_menu
    @win.refresh_display { @vendor.inventory.list(@win) }

    item_index = buy_prompt
    return exit_vendor if item_index == 'back'
    verify_buy(item_index.to_i)
  end

  def buy_prompt
    msgs = [Message.new('> Enter an item number to buy, or \'BACK\'.', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def verify_buy(item_index)
    item = @vendor.inventory.find_item(item_index)
    return not_recognized(:buy_menu) if item.nil?

    input = prompt_confirm_buy(item)
    buy_action(input, item)
  end

  def not_recognized(return_method)
    msgs = [Message.new('> Command not recognized.', 'red')]
    $message_win.display_messages(msgs)

    send(return_method)
  end

  def prompt_confirm_buy(item)
    msgs = [Message.new("> Are you sure you want to buy #{item.name} for #{(item.value * 1.2).floor}? (Y/N)", 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def buy_action(input, item)
    return buy_item(item) if ['y', 'yes'].include?(input)
    return buy_menu if ['n', 'no'].include?(input)

    msgs = [Message.new('> Reply not recognized, try again.', 'red')]
    $message_win.display_messages(msgs)

    verify_buy(item)
  end

  def buy_item(item)
    item_cost = (item.value * 1.2).floor
    return buy_menu if item_too_expensive?(item_cost)

    @player.inventory.money -= item_cost
    InventoryInteractor.new(@player, 'add', item).execute

    msgs = [Message.new("#{item.name} bought!", 'normal'), Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  def vendor_input_error
    msgs = [Message.new('> "I didn\'t get that"', 'red')]
    $message_win.display_messages(msgs)

    engage
  end

  def item_too_expensive?(item_cost)
    if item_cost > @player.inventory.money
      msgs = [Message.new('> Not enough money.', 'red')]
      $message_win.display_messages(msgs)

      true
    end
  end

  def exit_vendor
    msgs = [Message.new('> "Come back anytime."', 'normal'),
            Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end
end
