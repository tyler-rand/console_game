require 'spec_helper'

describe Player do
  describe '.open_all' do
    it 'returns all players' do
      Player.new(name: "Wally", password: "password", species: "Monster", type: "Green").save

      players = Player.open_all

      expect(players).not_to be_empty
      expect(players).to all(be_a(Player))

      # TODO: cleanup player.delete
    end
  end

  describe '.load' do
    context 'invalid username' do
      it 'returns error for name not found' do
        #
      end
    end

    context 'valid username, but invalid password' do
      it 'returns error for invalid password' do
        #
      end
    end

    context 'valid username and password' do
      it 'returns the corresponding player' do
        #
      end
    end
  end

  describe '#save' do
    it 'saves a player to do' do
      #
    end
  end

  describe '#update_stats' do
    it 'saves updates to damage and defense' do
      #
    end
  end

  describe '#add_exp' do
    context 'added xp is not enough to level up' do
      it 'adds exp' do
        #
      end
    end

    context 'added xp is enough to level up' do
      it 'adds exp and levels up player' do
        #
      end
    end
  end

  describe '#add_quest_rewards' do
    it 'gives player item, xp, and cash rewards for completing a quest' do
      #
    end
  end
end
