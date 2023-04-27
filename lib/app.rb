require_relative 'modules/store'
require_relative 'modules/table'
require_relative 'modules/prompt'
require_relative 'modules/utils'

class App
  include Store
  include Table
  include Prompt
  include Utils

  def initialize
    models = []

    Dir[File.join(__dir__, 'models', '*.rb')].sort.each do |file|
      require file
      file_name = pluralize(File.basename(file, '.rb'))
      models << file_name

      instance_variable_set("@#{file_name}", [])
    end

    load_saved_data.each do |key, value|
      instance_variable_set("@#{key}", value || [])
    end
  end

  private

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('list_')
      list_handler(method_name)
    elsif method_name.to_s.start_with?('create_')
      create_handler(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('list_') || method_name.to_s.start_with?('create_') || super
  end

  def create_handler(method_name, *args)
    klass = str_to_class(method_name.to_s.split('_')[1..].join('_'))

    pos_params, key_params = get_specific_parameters(klass)

    hash = {}
    if klass < Item
      hash = create_item
      pos_params -= hash.keys
      key_params -= hash.keys
    end

    args = args.first if args.first.is_a?(Hash)

    (pos_params + key_params).each_with_index do |param, i|
      arg = args.find { |k, _v| k.to_s.include?(param.to_s) }
      type = arg&.first || param
      question = arg&.last

      if i < pos_params.size
        pos_params[i] = ask_by_type(type, question)
      else
        hash[param] = ask_by_type(type, question)
      end
    end

    list, = find_array_instance_variable(method_name)

    list << klass.new(*pos_params, **hash)

    puts "#{klass} successfully created!\n----------------------\n\n"
  end

  def list_handler(method_name)
    list, var_name = find_array_instance_variable(method_name)

    if list.empty?
      puts "There are no items in the #{var_name.split('_').join(' ')}."
      return
    end

    if list.first.instance_variables.empty?
      puts "The #{var_name.split('_').join(' ')} is not a list of items."
      return
    end

    puts to_sentence_case(var_name)

    arr = []
    arr << list.first.instance_variables.map { |v| v.to_s.delete('@') }.map { |v| to_sentence_case(v) }

    list.each do |item|
      arr << item.instance_variables.map do |v|
        val = item.instance_variable_get(v)
        if val.is_a?(Array)
          val.size
        else
          val
        end
      end
    end

    arr.to_table
  end

  # look up for the instance variable in the class
  # eg list_books will find @books in the class
  def find_array_instance_variable(method_name)
    var_name = pluralize(method_name).to_s.split('_')[1..].join('_')
    list = instance_variable_get("@#{var_name}")

    if list.nil?
      puts "@#{var_name} does not exist."
      exit 1
    end

    unless list.is_a?(Array)
      puts "@#{var_name} is not a list."
      exit 1
    end

    [list, var_name]
  end

  # this method will ask common questions to create an item
  def create_item
    genre = ask_question(Genre, @genres)
    author = ask_question(Author, @authors)
    label = ask_question(Label, @labels)
    publish_date = ask_date 'What is the publish date?'

    { genre: genre, author: author, label: label, publish_date: publish_date }
  end
end
