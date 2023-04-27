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

  def load_saved_data
    data = {}
    items_hash = {}

    instance_variables.each do |var|
      name = var.to_s.delete('@')
      klass = str_to_class(name)
      if klass < Item
        items_hash[name.to_sym] = load_json(name, klass, raw: true)
      else
        data[name.to_sym] = load_json(name, klass)
      end
    end

    items_hash.each do |key, _|
      items_hash[key] = items_hash[key].map do |h|
        klass = str_to_class(key)

        # I created a separate class method to use for item classes
        # cuz it's depends on the data
        # you can use class_from_hash from Utils module
        klass.from_hash(h, data)
      end
    end

    data.merge!(items_hash)
    data
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

  # Create a path to save or load data
  def create_path(name)
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data', "#{name}.json"))
  end
end
