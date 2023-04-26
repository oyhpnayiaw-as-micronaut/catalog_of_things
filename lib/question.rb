require_relative 'utils'

module Question
  include Utils

  private

  # klass - Name of the class(Genre, Author, Label)
  # list - Item list from which to select
  # create_item_callback - Callback to create item if user wants to create
  # You can pass you own callback to create item if you think the default one is unsafe
  # See create_sub_item below for more info
  def ask_question(
    klass,
    list,
    create_item_callback = nil
  )
    # this method will ask question according to the parameters of the initialize method of the class
    # pass the create_item_callback if you think this is unsafe
    default_create_item_callback = lambda do
      fields = get_parameters(klass).map { |param| param[1] }

      hash = {}
      fields.map do |field|
        hash[field] = ask "What is the #{field} of #{klass}?"
      end

      item = class_from_hash(klass, hash)
      list << item
      item
    end

    create_item_callback ||= default_create_item_callback

    return create_item_callback.call if list.empty?

    result = ask "Do you want to create #{klass}(1) or select from the #{klass} list(2)?[1/2]"

    return create_item_callback.call if result == '1'

    select(list, klass)
  end

  # select item from the list
  # list - Item list from which to select
  # klass - Class object to create
  def select(list, klass)
    loop do
      puts "Select #{klass} from the list below by number"

      list.each_with_index do |item, index|
        puts "#{index + 1}). #{item}"
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
