# # handles equipping, dropping, using an item in a players inventory
# class InventoryInteractor
#   attr_accessor :id, :inventory, :command, :item_num

#   def initialize(inventory, command, item, item_num)
#   	@id        = object_id
#   	@inventory = inventory
#   	@command   = command
#   	@item      = item
#   	@item_num  = item_num
#   end

#   def execute
#   	method_name = "command_#{@command}".to_sym
#   	messages = send(method_name, @item_num)
#   	refresh_inventory_indexes
#   	messages
#   end

#   def command_equip(item_num)
#     @inventory.player.equipped.send("#{@item.type}=", @item)
#     @inventory.player.update_stats
#     messages = drop(item_num)
#     messages << Message.new("> #{item.name} equipped.", 'green')
#     messages
#   end

#   def command_drop(item_num)
#   	@inventory.items.slice!(item_num - 1)
#   	messages = [Message.new('> item removed from bag', 'normal')]
#   end

#   def refresh_inventory_indexes
#     @inventory.items = @inventory.items.map { |item, _| item }.each_with_index.map { |item, i| [item, i + 1] }
#   end

# end
