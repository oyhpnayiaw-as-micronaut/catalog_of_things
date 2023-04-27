require 'date'

require_relative 'utils'

module Prompt
  include Utils

  private

  # klass - Name of the class(Genre, Author, Label)
  # list - Item list from which to select
  # create_item_callback - Callback to create item if user wants to create
  # You can pass you own callback to create item if you think the default one is unsafe
  # See default_create_item_callback below for more info
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

      item = from_hash(klass, hash)
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

  def ask_inline(question)
    print question
    gets.chomp
  end

  def ask_date(question)
    date = ask("#{question} (YYYY-MM-DD)")
    date = Date.parse(date)
  rescue Date::Error
    puts 'Invalid date format please try again'
    retry
  end

  def ask_by_type(sym, question = nil)
    question = to_sentence_case(sym) if question.nil?
    question = question.delete_suffix('?')
    question += '?'

    sym = sym.to_s

    if sym.end_with?('_date')
      ask_date(question)
    elsif sym.end_with?('?')
      ask("#{question} (y/n)") == 'y'
    else
      ask(question)
    end
  end
end
