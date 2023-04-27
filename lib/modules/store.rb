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
      klass = convert_to_class(name)
      if klass.respond_to?(:depends_on)
        items_hash[name.to_sym] = name
      else
        data[name.to_sym] = load_json(name, klass)
      end
    end

    items_hash.each do |key, name|
      items_hash[key] = load_json(name, convert_to_class(name), data: data)
    end

    data.merge(items_hash)
  end

  # Load data from a JSON file
  def load_json(name, klass, data: {})
    path = create_path(name)
    if File.exist?(path)
      array = JSON.parse(File.read(path), symbolize_names: true)
      array.map { |hash| from_hash(klass, hash, data: data) }
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
