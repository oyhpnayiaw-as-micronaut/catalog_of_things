require 'date'

require_relative '../lib/item'
require_relative '../lib/genre'

describe Genre do
  let(:genre) { Genre.new('Action') }

  describe '#initialize' do
    it 'creates a new instance of Genre' do
      expect(genre).to be_an_instance_of Genre
    end

    it 'has a name' do
      expect(genre.name).to eq 'Action'
    end
  end

  describe '#add_item' do
    let(:item) { Item.new(genre: nil, author: nil, label: nil, publish_date: Date.today) }

    it 'adds an item to the genre' do
      genre.add_item(item)
      expect(genre.items).to include item
    end

    it 'does not add the same item twice' do
      genre.add_item(item)
      genre.add_item(item)
      expect(genre.items.size).to eq 1
    end
  end

  describe '#to_s' do
    it 'returns the genre name' do
      expect(genre.to_s).to eq 'Action'
    end
  end
end
