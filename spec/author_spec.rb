require 'date'

require_relative '../lib/item'
require_relative '../lib/author'

describe Author do
  let(:author) { Author.new('John', 'Doe') }

  describe '#initialize' do
    it 'creates a new instance of Author' do
      expect(author).to be_an_instance_of Author
    end

    it 'has a name' do
      expect(author.first_name).to eq 'John'
      expect(author.last_name).to eq 'Doe'
    end
  end

  describe '#add_item' do
    let(:item) { Item.new(genre: nil, author: nil, label: nil, publish_date: Date.today) }

    it 'adds an item to the author' do
      author.add_item(item)
      expect(author.items).to include item
    end

    it 'does not add the same item twice' do
      author.add_item(item)
      author.add_item(item)
      expect(author.items.size).to eq 1
    end
  end

  describe '#to_s' do
    it 'returns the author name' do
      expect(author.to_s).to eq 'John Doe'
    end
  end
end
