require_relative 'item'

class Book < Item
  attr_accessor :cover_state, :publisher

  def initialize(genre:, author:, label:, publish_date:, cover_state:, publisher:)
    super(genre: genre, author: author, label: label, publish_date: publish_date)
    @cover_state = cover_state
    @publisher = publisher
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end
end
