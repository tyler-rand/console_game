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
    @player.inventory.list(@win)
  end

  def buy_menu
    @vendor.inventory.list(@win)
  end

  def vendor_input_error
    msgs = [Message.new('> "I didn\'t get that"', 'red')]
    $message_win.display_messages(msgs)
    engage
  end
end
