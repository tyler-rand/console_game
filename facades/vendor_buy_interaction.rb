# vendor interaction in the buy menu
class VendorBuyInteraction
  def self.execute(win, player, vendor)
    @win = win
    @player = player
    @vendor = vendor

    buy_menu
  end

  # private class methods

  def self.buy_menu
    @win.refresh_display { @vendor.inventory.display(@win) }

    item_index = buy_prompt
    return VendorInteractor.close_vendor if item_index == 'back'
    verify_buy(item_index: item_index.to_i)
  end

  def self.buy_prompt
    msgs = [Message.new('> Enter an item number to buy, or \'BACK\'.', 'yellow'),
            Message.new('--> ', 'normal')]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.verify_buy(item_index: @item)
    @item = @vendor.inventory.find_item(item_index)
    if @item.nil?
      VendorInteractor.command_not_recognized
      return buy_menu
    end

    input = prompt_confirm_buy
    buy_action(input)
  end

  def self.prompt_confirm_buy
    msgs = [
      Message.new("> Really buy #{@item.name} for #{(@item.value * 1.2).floor}? (Y/N)", 'yellow'),
      Message.new('--> ', 'normal')
    ]
    $message_win.display_messages(msgs)

    $message_win.get_input
  end

  def self.buy_action(input)
    case input
    when 'yes', 'y' then buy_item
    when 'no', 'n' then buy_menu
    else
      VendorInteractor.command_not_recognized
      verify_buy
    end
  end

  def self.buy_item
    item_cost = (@item.value * 1.2).floor
    return buy_menu if item_too_expensive?(item_cost)

    @player.inventory.money -= item_cost
    InventoryInteractor.new(@player, nil, nil).add_item(@item)

    item_bought_message
  end

  def self.item_too_expensive?(item_cost)
    return false unless item_cost > @player.inventory.money

    $message_win.display_messages(Message.new('> Not enough money.', 'red'))

    true
  end

  def self.item_bought_message
    msgs = [Message.new("#{@item.name} bought!", 'normal'), Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
  end

  private_class_method :buy_menu, :buy_prompt, :verify_buy, :prompt_confirm_buy, :buy_action,
                       :buy_item, :item_too_expensive?, :item_bought_message
end
