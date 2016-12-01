class AttackTurn
  attr_reader :battle, :player, :mob, :battle_displayer, :map

  def initialize(battle:)
    @battle = battle
    @player = battle.player
    @mob = battle.mob
    @battle_displayer = battle.battle_displayer
    @map = battle.map
  end

  def execute
    player_attack

    if mob.health <= 0
      killed_mob
    else
      mob_attack
    end
  end

  private

  def player_attack
    damage = adjusted_attack_damage(player, mob)
    mob.health -= damage
    battle.battle_displayer.refresh(self)
    $message_win.display_messages(Message.new("> You hit #{mob.name} for #{damage}!", 'green'))
  end

  def adjusted_attack_damage(attacker, defender)
    (attacker.damage * defense_adjusted_dmg_percent(defender)).round(0)
  end

  def defense_adjusted_dmg_percent(defender)
    defense = defender.defense
    count = 0

    while defense >= 20
      count += 1
      defense -= 20
    end

    # defense_dmg_reduction_table[defender.level-1][count*20]
    0.4 # til method is fixed
  end

  # def defense_dmg_reduction_table # FIXME: if defense doesnt fall into preset values... need a better way to do this
  #   [
  #     { 'level' => 1, 0 => 1, 20 => 0.8, 40 => 0.6, 60 => 0.4, 80 => 0.2 },
  #     { 'level' => 2, 0 => 1, 40 => 0.8, 80 => 0.6, 120 => 0.4, 160 => 0.2 },
  #     { 'level' => 3, 0 => 1, 60 => 0.8, 120 => 0.6, 180 => 0.4, 240 => 0.2 }
  #   ]
  # end

  def killed_mob
    msgs = [Message.new("> You killed it! Gained #{mob.level} exp.", 'green'),
            Message.new('> ', 'normal')]
    $message_win.display_messages(msgs)

    battle_displayer.clear
    map.remove_at_loc(battle.location)
    player.add_exp(mob.level)

    battle.state = 1

    battle.map_movement.execute

    trigger = { category: 'killed_mob', mob: mob }
    EventTrigger.new(player: player, trigger: trigger).execute
  end

  def mob_attack
    damage = adjusted_attack_damage(mob, player)
    player.health -= damage
    battle_displayer.refresh(self)
    $message_win.display_messages(Message.new("> #{mob.name} hits you for #{damage}!", 'red'))

    mob_kills_player if player.health <= 0 && mob.health > 0
  end

  def mob_kills_player
    battle_displayer.clear
    map.remove_at_loc(player.location)
    battle.state = 1
    player.health = 0
    player.location = []

    $message_win.display_messages(Message.new('> You died.', 'red'))
  end
end
