require 'spec_helper'

describe Map do
  describe '.open_all' do
    it 'returns all maps' do
      maps = Map.open_all

      expect(maps).not_to be_empty
      expect(maps).to all(be_a(Map))
    end
  end

  describe '.load' do
    context 'valid map name' do
      it 'returns the map' do
        map = Map.load("Trainers Court")

        expect(map.class).to eq(Map)
      end
    end

    context 'invalid map name' do
      it 'returns nil' do
        map = Map.load("invalid map name")

        expect(map).to eq(nil)
      end
    end
  end

  describe '.names' do
    it 'returns array of all map names' do
      names = Map.names

      expect(names).not_to be_empty
      expect(names).to all(be_a(String))
      expect(names[0..2]).to eq(["Trainers Court", "Trainers Mansion", "Road To City"])
    end
  end

  describe '.list_all' do
    it 'lists all map names in the game window' do
      #
    end
  end

  describe '#save' do
    it 'saves map to yml database file' do
      #
    end
  end

  describe '#find_player' do
    it 'returns location of the player' do
      #
    end
  end

  describe '#remove_at_loc' do
    it 'turns a location into an open space' do
      # 
    end
  end
end
