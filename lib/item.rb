class Item
  attr_reader :genre, :author, :label, :publish_date

  def initialize(genre:, author:, label:, publish_date:)
    @id = Random.rand(1000)
    self.genre = genre
    self.author = author
    self.label = label
    @publish_date = publish_date
    @archived = false
  end

  def can_be_archived?
    @publish_date < Date.today.prev_year(10)
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end

  # setters
  def genre=(genre)
    @genre&.items&.delete(self)
    @genre = genre
    @genre&.items&.<< self
  end

  def author=(author)
    @author&.items&.delete(self)
    @author = author
    @author&.items&.<< self
  end

  def label=(label)
    @label&.items&.delete(self)
    @label = label
    @label&.items&.<< self
  end
end
