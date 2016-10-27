class VendorInteractor
  attr_accessor :id, :vendor, :player

  def initialize(player:, vendor:, win:)
    @id     = object_id
    @player = player
    @vendor = vendor
    @win    = win
  end

  def self.open_vendor?(vendor_type)
    vendor_welcome_message(vendor_type)

    input = $message_win.get_input

    if %w(yes y).include?(input)
      true
    elsif %w(no n).include?(input)
      close_vendor
    else
      command_not_recognized { open_vendor?(vendor_type) }
    end
  end

  def self.vendor_welcome_message(vendor_type)
    msgs = if vendor_type == :shop
             [Message.new('> Take a look at the shop? (Y/N)', 'yellow')]
           elsif vendor_type == :quest
             [Message.new('> New quest found! Check it out? (Y/N)', 'yellow')]
           end

    msgs << Message.new('--> ', 'normal')
    $message_win.display_messages(msgs)
  end

  def self.close_vendor
    msgs = [Message.new(Vendor::EXIT_MSGS.sample, 'yellow'), Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)
    false
  end

  def self.command_not_recognized
    msgs = [Message.new(Vendor::INPUT_ERR_MSGS.sample, 'red')]
    $message_win.display_messages(msgs)
    yield
  end

  def engage
    input = vendor_action_prompt

    if input[0] == 'sell'
      VendorSellInteraction.execute(@win, @player)
    elsif input[0] == 'buy'
      VendorBuyInteraction.execute(@win, @player, @vendor)
    else
      VendorInteractor.command_not_recognized { engage }
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
end
