require 'date'

class ::Symbol
  def pluralize
    "#{self}s".to_sym
  end
end

class Item
  attr_reader :genre, :author, :label
  attr_accessor :publish_date

  def initialize(genre:, author:, label:, publish_date:)
    @id = Random.rand(1000)
    self.genre = genre
    self.author = author
    self.label = label
    @publish_date = publish_date
    @archived = false
  end

  def to_hash
    {
      id: @id,
      genre: @genre&.instance_variable_get(:@id),
      author: @author&.instance_variable_get(:@id),
      label: @label&.instance_variable_get(:@id),
      publish_date: @publish_date,
      archived: @archived
    }
  end

  def self.from_hash(hash, data = {})
    parameters = instance_method(:initialize).parameters.map { |param| param[1] }
    ctor_hash = hash.select { |key, _| parameters.include?(key) }

    %i[genre author label].each do |key|
      ctor_hash[key] = data[key.pluralize]&.find do |item|
        item.instance_variable_get(:@id) == ctor_hash[key]
      end
    end

    ctor_hash[:publish_date] = Date.parse(ctor_hash[:publish_date])

    item = new(**ctor_hash)

    rest_hash = hash.reject { |key, _| parameters.include?(key) }
    rest_hash.each do |key, value|
      item.instance_variable_set("@#{key}", value)
    end
    item
  end

  def can_be_archived?
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
