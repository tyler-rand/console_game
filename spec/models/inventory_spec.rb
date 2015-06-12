require 'spec_helper'

describe Inventory do
  it 'should build an inventory' do
    player = build(:player)
    inventory = player.inventory

    expect(inventory.class).to eql(Inventory)
  end
end
