require 'securerandom'

class Item
  attr_reader :genre, :author, :source, :label, :publish_date

  def initialize(genre:, author:, source:, label:, publish_date:)
    @id = SecureRandom.uuid
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = false
  end

  def can_be_archived?
    @publish_date < Date.today.prev_year(10)
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end
end
