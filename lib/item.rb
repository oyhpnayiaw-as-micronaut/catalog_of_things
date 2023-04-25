require 'securerandom'

class Item
  attr_reader :genre, :author, :source, :label, :publish_date

  def initialize(genre, author, source, label, publish_date)
    @id = SecureRandom.uuid
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = false
  end

  def can_be_archived?
    difference = Date.today.year - @publish_date.year
    difference > 10
  end

  def move_to_archive
    return unless can_be_archived?

    @archived = true
  end
end
