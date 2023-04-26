require 'date'

require_relative '../lib/item'
require_relative '../lib/book'

describe Book do
  let(:book) do
    Book.new(genre: nil, author: nil, label: nil, publish_date: Date.today, cover_state: 'bad', publisher: '')
  end

  describe '#initialize' do
    it 'creates a new instance of Book' do
      expect(book).to be_an_instance_of Book
    end
  end

  describe '#can_be_archived?' do
    it 'returns true if the cover state bad' do
      expect(book.can_be_archived?).to be true
    end
  end
end
