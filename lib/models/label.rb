class Label
  attr_accessor :title, :color, :items

  def initialize(title, color)
    @id = Random.rand(1000)
    @title = title
    @color = color
    @items = []
  end

  def add_item(item)
    item.label = self
  end

  def to_s
    "#{title} (#{color})"
  end
end
