require 'json'
require 'date'

require_relative 'utils'

module Store
  include Utils

  def save_data
    instance_variables.each do |var|
      name = var.to_s.delete('@')
      data = instance_variable_get(var)
      if data.is_a?(Array) && !data.empty?
        File.write(create_path(name), JSON.pretty_generate(data.map { |item| to_hash(item) }))
      end
    end
  end

  private

  def load_all_data
    hash = {}
    items_hash = {}

    instance_variables.each do |var|
      name = var.to_s.delete('@')
      klass = convert_to_class(name)
      if klass < Item
        items_hash[name.to_sym] = load_json(name, klass, raw: true)
      else
        hash[name.to_sym] = load_json(name, klass)
      end
    end

    items_hash.each do |key, _|
      items_hash[key] = items_hash[key].map do |item|
        klass = convert_to_class(key)

        # Item is a parent class for all other classes
        # For Item classes it is somewhat complicated that's why
        # I created a separate class method to use
        # for other classes I can use Utils::class_from_hash
        klass.from_hash(item, hash)
      end
    end

    hash.merge!(items_hash)
    hash
  end

  # Load data from a JSON file
  def load_json(name, klass, raw: false)
    path = create_path(name)
    if File.exist?(path)
      data = JSON.parse(File.read(path), symbolize_names: true)
      data = data.map { |hash| class_from_hash(klass, hash) } unless raw
      data
    else
      []
    end
  rescue JSON::ParserError
    puts "Error: #{path} is not a valid JSON file"
    []
  end

  # Convert a string to an actual class
  # Reseach Object.const_get to understand this method
  def convert_to_class(name)
    klass = name.to_s.split('_').map(&:capitalize).join
    klass.chop! if klass.end_with?('s')
    Object.const_get(klass)
  end

  # Create a path to save or load data
  def create_path(name)
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data', "#{name}.json"))
  end

  # Convert class instance to hash
  # This method handle every class from the project to convert it to a hash
  def to_hash(instance)
    hash = {}
    instance.instance_variables.each do |var|
      value = instance.instance_variable_get(var)
      key = var.to_s.delete('@').to_sym

      hash[key] = if value.is_a?(Array) && !value.empty? && value.first.is_a?(Item)
                    value.map { |item| item.instance_variable_get(:@id) }
                  else
                    value
                  end
    end

    # Converting Item class to hash is a special case
    # cuz it's different from the other classes in the project
    # read more about it in item.rb
    hash = hash.merge(instance.to_hash) if instance.is_a?(Item)
    hash
  end
end
