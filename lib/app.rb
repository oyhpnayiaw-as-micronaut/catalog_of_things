require 'io/console'

require_relative 'modules/store'
require_relative 'modules/table'
require_relative 'modules/prompt'
require_relative 'modules/utils'

class App
  include Store
  include Table
  include Prompt
  include Utils

  @@models = []
  @@hidden_list = []
  @@hidden_create = []

  # models: array of models that come from outside of the models folder
  #  - ps. you need to import them at the entry point of the app. e.g: main.rb
  # hidden_list: array of models that you don't want to show in the list (on the console)
  # hidden_create: array of models that you don't want to show in the create (on the console)
  def initialize(models: [], hidden_list: [], hidden_create: [])
    @@hidden_list = hidden_list
    @@hidden_create = hidden_create

    Dir[File.join(__dir__, 'models', '*.rb')].sort.each do |file|
      require file
      file_name = pluralize(File.basename(file, '.rb'))
      @@models << file_name

      instance_variable_set("@#{file_name}", [])
    end

    models.each do |model|
      next if @@models.include?(model) || !model.is_a?(Symbol)
      next unless class_is_defined?(model)

      @@models << pluralize(singularize(model)).to_sym
      instance_variable_set("@#{model}", [])
    end

    load_saved_data.each do |key, value|
      instance_variable_set("@#{key}", value || [])
    end
  end

  def start
    options = []
    @@models.each do |model|
      unless @@hidden_list.include?(singularize(model).to_sym)
        options << {
          message: "List all #{to_sentence_case(model).downcase}",
          handler: "list_#{model}"
        }
      end

      # rubocop:disable Style/Next
      unless @@hidden_create.include?(singularize(model).to_sym)
        options << {
          message: "Add a new #{singularize(to_sentence_case(model).downcase)}",
          handler: "add_#{model}"
        }
      end
    end

    options.sort_by! { |option| option[:message] }.reverse!

    puts "Welcome to the app!\n\n"

    loop do
      puts 'Please select an option:'

      options.each_with_index do |option, i|
        puts "#{i + 1}). #{option[:message]}"
      end
      puts "\nSelect 'q' to exit "

      option = ask_inline '> '
      exit_app if option == 'q'

      clear_console

      if option.to_i.between?(1, options.size)
        method = options[option.to_i - 1][:handler]
        send(method)
      else
        puts 'Invalid option'
      end

      puts 'Press q to exit or any other key to continue'
      exit_app if $stdin.getch == 'q'

      clear_console
    end
  rescue Interrupt
    exit_app
  end

  private

  def clear_console
    system('clear') || system('cls')
  end

  def exit_app
    puts "\nThank you for using our app."
    save_data
    exit
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('list_')
      list_handler(method_name)
    elsif method_name.to_s.start_with?('add_')
      add_handler(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('list_') || method_name.to_s.start_with?('add_') || super
  end

  def add_handler(method_name, *args)
    klass = convert_to_class(method_name.to_s.split('_')[1..].join('_'))

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
