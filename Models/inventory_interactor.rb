# # handles equipping, dropping, using an item in a players inventory
# class InventoryInteractor
#   attr_accessor :id, :inventory, :command, :player, :item, :item_num

#   def initialize(inventory, command, item, item_num)
#   	@id       = object_id
#   	@inventory = inventory
#   	@command  = command
#   	@player   = inventory.player
#   	@item     = item
#   	@item_num = item_num
#   end

#   def execute
#   	method_name = "command_#{command}".to_sym
#   	messages = send(method_name, item_num)
#   	refresh_inventory_indexes
#   	messages
#   end

#   def command_equip(item_num)
#     player.equipped.send("#{item.type}=", item)
#     player.update_stats
#     messages = command_drop(item_num)
#     messages << Message.new("> #{item.name} equipped.", 'green')
#     messages
#   end

#   def command_drop(item_num)
#   	inventory.items.slice!(item_num - 1)
#   	messages = [Message.new("> #{item.name} removed from bag", 'green')]
#   	messages
#   end

#   def refresh_inventory_indexes
#     inventory.items = inventory.items.map { |it, _| it }.each_with_index.map { |it, i| [it, i + 1] }
#   end

# end
