module Question
  private

  # name - Name of the class(Genre, Author, Label)
  # list - Item list from which to select
  # create_item_callback - Callback to create item if user wants to create
  # attr_key - Attribute key to display in the list
  def ask_question(
    name,
    list,
    create_item_callback,
    attr_key
  )
    return create_item_callback.call if list.empty?

    result = ask "Do you want to create #{name}(1) or select from the #{name} list(2)?[1/2]"

    return create_item_callback.call if result == '1'

    select(list, name, attr_key)
  end

  def select(list, name, attr_key)
    loop do
      puts "Select #{name} from the list below by number"

      list.each_with_index do |item, index|
        puts "#{index + 1}). #{item.instance_variable_get("@#{attr_key}")}"
      end

      index = gets.chomp.to_i

      return list[index - 1] if index.positive? && index <= list.size

      puts 'Invalid selection'
    end
  end

  def ask(question)
    puts question
    gets.chomp
  end
end
