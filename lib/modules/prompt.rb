require 'date'

require_relative 'utils'

module Prompt
  include Utils

  private

  def ask_question(name, questions: {})
    klass = convert_to_class(name)

    params = get_parameters(klass).map { |param| param[1] }
    depends_on = klass.depends_on if klass.respond_to?(:depends_on)

    hash = {}
    params.each do |param|
      if depends_on.nil? || depends_on.empty? || !depends_on.include?(param)
        possible_questions = questions[singularize(name)] || {}
        val = possible_questions.find { |k, _v| k.to_s.include?(param.to_s) }
        type = val&.first || param
        question = val&.last || "What is the #{param} for #{to_sentence_case(singularize(name))}?"
        hash[param] = ask_by_type(type, question)
        next
      end

      list = instance_variable_get("@#{pluralize(param)}")

      if list.nil? || list.empty?
        hash[param] = ask_question(param, questions: questions)
        next
      end

      result = ask "Do you want to create #{param}(1) or select from the #{param} list(2)?[1/2]"

      unless [1, 2].include?(result.to_i)
        puts 'Invalid selection'
        redo
      end

      if result == '1'
        hash[param] = ask_question(param, questions: questions)
        next
      end

      hash[param] = select(list, param)
      next
    end

    model = from_hash(klass, hash, is_new: true)
    list = instance_variable_get("@#{pluralize(name)}")
    list << model
    model
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
