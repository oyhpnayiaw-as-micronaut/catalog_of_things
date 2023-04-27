require 'date'

class Item
  attr_reader :genre, :author, :label
  attr_accessor :publish_date

  def initialize(genre:, author:, label:, publish_date:)
    @id = Random.rand(1000)
    self.genre = genre
    self.author = author
    self.label = label
    @archived = false
    @publish_date = begin
      Date.parse(publish_date.to_s)
    rescue StandardError
      nil
    end
  end

  def self.depends_on
    %i[genre author label]
  end

  def can_be_archived?
    return false if @publish_date.nil?

    @publish_date < Date.today.prev_year(10)
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end

  # setters
  def genre=(genre)
    return if genre.is_a?(String) || genre.is_a?(Numeric)

    @genre&.items&.delete(self)
    @genre = genre
    @genre&.items&.<< self
  end

  def author=(author)
    return if author.is_a?(String) || author.is_a?(Numeric)

    @author&.items&.delete(self)
    @author = author
    @author&.items&.<< self
  end

  def label=(label)
    return if label.is_a?(String) || label.is_a?(Numeric)

    @label&.items&.delete(self)
    @label = label
    @label&.items&.<< self
  end
end
