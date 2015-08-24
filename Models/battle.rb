# battle between player and mob
class Battle
  attr_accessor :id, :state, :player, :mob, :map

  #
  ## CLASS METHODS
  #

  def initialize(player, mob, map)
    @id     = object_id
    @state  = 0 # 0 is ongoing battle, 1 is battle ended
    @player = player
    @mob    = mob
    @map    = map
  end

  def killed_mob
    map.current_map[mob.location[0]][mob.location[1]]       = 'P'
    map.current_map[player.location[0]][player.location[1]] = '.'

    player.set_location(map.current_map)
    player.update_exp(mob.level)

    messages = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green')]
    self.state = 1
    messages
  end

  def initiate_attack
    mob.health -= player.damage
    messages = [Message.new("> You hit #{mob.name} for #{player.damage}!", 'green')]

    # Player kills mob
    if mob.health <= 0 && player.health > 0
      killed_mob.each { |result_msg| messages << result_msg }

    # Mob attacks back
    else
      mob_attack.each { |result_msg| messages << result_msg }
    end

    messages
  end

  def mob_attack
    player.health -= mob.damage
    messages = [Message.new("> #{mob.name} hits you for #{mob.damage}!", 'red'), Message.new('> ATTACK | BAG | RUN', 'yellow')]

    # Mob kills player
    if player.health <= 0 && mob.health > 0
      messages << Message.new('> You died.', 'red')
      self.state = 1
      player.health = 0
      # player.find_new_loc('c')
    else
      messages << Message.new('--> ', 'normal')
    end

    messages
  end

  def attempt_run
    if [*1..100].sample > 25
      messages = [Message.new('> Got away!', 'green')]
      self.state = 1
    else
      messages = [Message.new('> Couldn\'t escape!', 'red')]
      mob_attack.each { |result_msg| messages << result_msg }
    end

    messages
  end
end
