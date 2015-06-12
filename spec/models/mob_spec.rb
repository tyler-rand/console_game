require 'spec_helper'

describe Mob do
  it 'should build a mob factory' do
    mob = build(:mob)

    expect(mob.name).to_not eql(nil)
  end
end
