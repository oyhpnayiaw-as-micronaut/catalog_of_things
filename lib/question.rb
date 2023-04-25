module Question
  private

  # name - Name of the class(Genre, Author, Label)
  # list - Item list from which to select
  # attr_key - Attribute key to display in the list
  # create_item_callback - Callback to create item if user wants to create
  # You can pass you own callback to create item if you think the default one is unsafe
  # See create_sub_item below for more info
  def ask_question(
    class_object,
    list,
    attr_key,
    create_item_callback = nil
  )
    # honestly, this method is very dangerous to use
    # You have to create a class with positional arguments
    # and the arguments have to be in the same order when setting them
    # pass the create_item_callback if you think this is unsafe
    default_create_item_callback = lambda do
      fields = get_attrs(class_object)

      values = fields.map do |field|
        ask "What is the #{field} of #{class_object}?"
      end

      item = class_object.new(*values)
      list << item
      item
    end

    create_item_callback ||= default_create_item_callback

    return create_item_callback.call if list.empty?

    result = ask "Do you want to create #{class_object}(1) or select from the #{class_object} list(2)?[1/2]"

    return create_item_callback.call if result == '1'

    select(list, class_object, attr_key)
  end

  # select item from the list
  # list - Item list from which to select
  # class_object - Class object to create
  # attr_key - Attribute key to display in the list
  def select(list, class_object, attr_key)
    loop do
      puts "Select #{class_object} from the list below by number"

      list.each_with_index do |item, index|
        puts "#{index + 1}). #{item.instance_variable_get("@#{attr_key}")}"
      end

      index = gets.chomp.to_i

      return list[index - 1] if index.positive? && index <= list.size

      puts 'Invalid selection'
    end
  end

  # get settable attributes of the class
  # class_object - Class object to get attributes from
  def get_attrs(class_object)
    class_object.instance_methods(false)
      .select { |method| method.to_s.end_with?('=') }
      .map { |method| method.to_s.gsub('=', '') }
      .reject { |method| method.to_s.start_with?('==') || %w[id items].include?(method.to_s) }
  end

  def ask(question)
    puts question
    gets.chomp
  end
end
