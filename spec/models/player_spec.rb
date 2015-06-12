require 'spec_helper'

describe Player do
  it 'should build a new player' do
    player = build(:player)
    p player
  end

  it 'should load a player by login info' do
    player = build(:player)
    player.save

    loaded = Player.load_by_credentials(player.name, player.password)
  end

  it 'should load a saved player by id' do
    player = build(:player)
    player.save

    loaded = Player.load_by_id(player.id)
  end

  it 'should update a players exp' do
    player = build(:player)
    exp    = player.current_exp
    n      = [*1..5].sample

    player.update_exp(n)

    new_exp = player.current_exp

    expect(exp + n).to eql(new_exp)
  end

  it 'should update a players stats' do
    # player.update_stats
  end
end
