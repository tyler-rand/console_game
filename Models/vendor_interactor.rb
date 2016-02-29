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

    input = $message_win.win.getstr.downcase
    $message_win.message_log.append(input)

    input.split(' ')
  end

  def sell_menu
    @win.refresh_display { @player.inventory.list(@win) }

    item_index = sell_prompt
    verify_sell(item_index)
  end

  def sell_prompt
    msgs = [Message.new('> Enter an item number to sell.', 'yellow'),
            Message.new('-->', 'normal')]
    $message_win.display_messages(msgs)

    input = $message_win.win.getstr.downcase
    $message_win.message_log.append(input)

    input.to_i
  end

  def verify_sell(item_index)
    item = @player.inventory.find_item(item_index)

    msgs = [Message.new("> Are you sure you want to sell #{item.name} for #{item.value}?", 'yellow'),
            Message.new('> YES | NO', 'yellow'),
            Message.new('-->', 'normal')]

    $message_win.display_messages(msgs)

    input = $message_win.win.getstr.downcase
    $message_win.message_log.append(input)

    if input == 'yes'
      @player.inventory.money += item.value
      interaction = InventoryInteractor.new(@player, 'drop', item_index)
      interaction.execute
    elsif input == 'no'
      false
    else
      msgs = [Message.new('> Reply not recognized, try again.', 'red')]
      $message_win.display_messages(msgs)
      verify_sell(item)
    end
  end

  def buy_menu
    @win.refresh_display { @vendor.inventory.list(@win) }

    item_index = buy_prompt
    item = @vendor.inventory.find_item(item_index)
    verify_buy(item)
  end

  def buy_prompt
    msgs = [Message.new('> Enter an item number to buy.', 'yellow'),
            Message.new('-->', 'normal')]
    $message_win.display_messages(msgs)

    input = $message_win.win.getstr.downcase
    $message_win.message_log.append(input)

    input
  end

  def verify_buy(item)

  end

  def vendor_input_error
    msgs = [Message.new('> "I didn\'t get that"', 'red')]
    $message_win.display_messages(msgs)
    engage
  end
end
