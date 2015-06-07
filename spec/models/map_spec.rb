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
  end

end