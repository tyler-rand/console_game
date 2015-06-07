require 'spec_helper'

describe Map do

  it 'should build a new map' do
    map = build(:map)
  end

  it 'should load mobs ary for map' do
  	map = build(:map)
  	map.load_current_map
  	map.load_mobs

  	expect(map.mobs.first[1].class).to eql(Mob)
  end

  it 'should move a player' do
    map = build(:map)
    player = build(:player)

    map.load_current_map
    player.set_location(map.current_map)
    old_loc = player.location

    new_player_loc = player.find_new_loc(%w(w a d).sample, map.current_map)
    map.move_player(player: player, new_player_loc: new_player_loc)

    expect(player.location).to_not eql(old_loc)
  end

end