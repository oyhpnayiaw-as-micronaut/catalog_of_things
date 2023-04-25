require_relative 'item'

class Book < Item
  attr_accessor :title, :author, :publisher, :num_pages, :cover_state

  def initialize(author, title:, publisher:, num_pages:, cover_state:)
    super(author, title, publisher, num_pages, cover_state)
    @title = title
    @publisher = publisher
    @num_pages = num_pages
    @cover_state = cover_state
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end
end
