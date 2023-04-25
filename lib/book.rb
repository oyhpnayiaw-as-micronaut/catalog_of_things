require './item'
class Book < Item
  def initialize(genre:, author:, label:, publish_date:, cover_state:, publisher:)
    super(genre: genre, author: author, label: label, publish_date: publish_date)
    @cover_state = cover_state
    @publisher = publisher
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end

  def self.all
    super.select { |item| item.is_a? Book }
  end

  def add_book(genre:, author:, label:, publish_date:, cover_state:, publisher:)
    book = Book.new(genre: genre, author: author, label: label, publish_date: publish_date, cover_state: cover_state,
                    publisher: publisher)
    Label.all.find { |l| l.name == label }.add_item(book)
    Item.save_all(Item.all + [book])
    Label.save_all(Label.all)
  end
end
