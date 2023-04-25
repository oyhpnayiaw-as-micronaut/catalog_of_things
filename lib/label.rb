class Label
  attr_accessor :name, :items

  def initialize(name)
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item
    item.label = self
  end

  def self.all
    JSON.parse(File.read('labels.json')).map do |label_data|
      label = Label.new(label_data['name'])
      label_data['item_ids'].each do |item_id|
        item = Item.all.find { |i| i.object_id == item_id }
        label.add_item(item)
      end
      label
    end
  end

  def self.save_all(labels)
    File.write('labels.json', labels.to_json)
  end

  def to_json(*args)
    { name: @name, item_ids: @items.map(&:object_id) }.to_json(*args)
  end

  def list_books
    Book.all.each do |book|
      puts "Title: #{book.title}\nGenre: #{book.genre}\nAuthor: #{book.author}\nPublisher: #{book.publisher}\n"
    end
  end

  def list_labels
    Label.all.each do |label|
      puts "Label: #{label.name}\nNumber of Items: #{label.items.count}\n"
    end
  end
end
