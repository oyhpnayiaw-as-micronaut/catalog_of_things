require 'date'

require_relative '../lib/item'
require_relative '../lib/label'

describe Label do
  let(:label) { Label.new('Title', 'Color') }

  describe '#initialize' do
    it 'creates a new instance of Label' do
      expect(label).to be_an_instance_of Label
    end

    it 'has a Title and Color' do
      expect(label.title).to eq 'Title'
      expect(label.color).to eq 'Color'
    end
  end

  describe '#add_item' do
    let(:item) { Item.new(genre: nil, author: nil, label: nil, publish_date: Date.today) }

    it 'adds an item to the label' do
      label.add_item(item)
      expect(label.items).to include item
    end

    it 'does not add the same item twice' do
      label.add_item(item)
      label.add_item(item)
      expect(label.items.size).to eq 1
    end
  end

  describe '#to_s' do
    it 'returns the label' do
      expect(label.to_s).to eq 'Title (Color)'
    end
  end
end