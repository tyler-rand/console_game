require 'spec_helper'

describe Quest do
  describe '.find' do
    context 'invalid map name' do
      it 'returns nil' do
        #
      end
    end

    context 'invalid location' do
      it 'returns nil' do
        #
      end
    end

    context 'valid map name and location' do
      it 'finds a quest for the given map name and given location' do
        #
      end
    end
  end

  describe '.all' do
    it 'returns all quests in the db' do
      quests = Quest.all

      expect(quests).not_to be_empty
      expect(quests).to all(be_a(Quest))
    end
  end

  describe '#save' do
    it 'saves a quest to the db' do
      #
    end
  end

  describe '#formatted_rewards' do
    it 'returns a formatted quest reward string' do
      #
    end
  end

  describe '#completed?' do
    context 'quest is completed' do
      it 'returns true' do
        #
      end
    end

    context 'quest isn\'t completed' do
      it 'returns false' do
        #
      end
    end
  end
end
