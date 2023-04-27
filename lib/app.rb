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
  @@questions = {}

  # models: array of models that come from outside of the models folder
  #  - ps. you need to import them at the entry point of the app. e.g: main.rb
  # hidden_list: array of models that you don't want to show in the list (on the console)
  # hidden_create: array of models that you don't want to show in the create (on the console)
  def initialize(models: [], hidden_list: [], hidden_create: [], questions: {})
    @@hidden_list = hidden_list
    @@hidden_create = hidden_create
    @@questions = questions

    Dir[File.join(__dir__, 'models', '*.rb')].sort.each do |file|
      require file
      file_name = File.basename(file, '.rb')
      add_to_model(file_name.to_sym)
    end

    models.each { |model| add_to_model(model) }

    load_saved_data.each do |key, value|
      instance_variable_set("@#{key}", value || [])
    end
  end

  def start
    options = []
    @@models.each do |model|
      unless @@hidden_list.include?(singularize(model))
        options << {
          message: "List all #{to_sentence_case(model).downcase}",
          handler: "list_#{model}"
        }
      end

      # rubocop:disable Style/Next
      unless @@hidden_create.include?(singularize(model))
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

  def exit_app
    puts "\nThank you for using our app."
    save_data
    exit
  end

  def add_to_model(model)
    return unless model.is_a?(Symbol)
    return unless class_is_defined?(model)
    return if get_parameters(convert_to_class(model)).empty?

    model = pluralize(model)
    return if @@models.include?(model)

    @@models << model
    instance_variable_set("@#{model}", [])
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('list_')
      handle_list_method(method_name)
    elsif method_name.to_s.start_with?('add_')
      handle_add_method(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('list_') || method_name.to_s.start_with?('add_') || super
  end

  def handle_add_method(method_name)
    model_name = method_name.to_s.split('_')[1..].join('_')
    ask_question(model_name, questions: @@questions)
  end

  def handle_list_method(method_name)
    var_name = pluralize(method_name).to_s.split('_')[1..].join('_')
    list = instance_variable_get("@#{var_name}")

    if list.nil?
      puts "@#{var_name} does not exist."
      return
    end

    unless list.is_a?(Array)
      puts "@#{var_name} is not a list."
      return
    end

    if list.empty?
      puts "There are no items in the #{var_name}."
      return
    end

    if list.first.instance_variables.empty?
      puts "#{to_class_case(var_name)} don't have any attributes."
      return
    end

    puts " List of #{to_sentence_case(var_name)}\n#{'-' * (var_name.size + 10)}\n"

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
end
