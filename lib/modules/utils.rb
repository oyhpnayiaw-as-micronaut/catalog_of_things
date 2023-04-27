module Utils
  private

  # Convert hash to class instance
  # This method will work well if the class don't convert during initialization
  # klass - Class object
  # hash - Hash object
  def class_from_hash(klass, hash)
    pos_params, key_params = get_specific_parameters(klass)

    pos_params = pos_params.map { |param| hash[param] }
    key_params = hash.select { |key, _| key_params.include?(key) }

    instance = klass.new(*pos_params, **key_params)
    hash.each do |key, value|
      instance.instance_variable_set("@#{key}", value)
    end

    instance.instance_variable_set(:@items, []) if instance.respond_to?(:items)
    instance
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
                  elsif instance.is_a?(Item) && value.instance_variable_defined?(:@id)
                    value.instance_variable_get(:@id)
                  else
                    value
                  end
    end
    hash
  end

  # Convert a string to an actual class
  # Reseach Object.const_get to understand this method
  def str_to_class(str, remove_s: true)
    klass = str.to_s.split('_').map(&:capitalize).join
    klass.chop! if klass.end_with?('s') && remove_s
    return Object.const_get(klass) if Object.const_defined?(klass)

    puts "#{klass} is not a valid class."
    exit 1
  end

  def to_sentence_case(str = '')
    str.to_s.split('_').map(&:capitalize).join(' ')
  end

  def get_parameters(klass)
    klass.instance_method(:initialize).parameters
  end

  def get_specific_parameters(klass)
    params = get_parameters(klass)
    pos_params = params.select { |param| param[0] == :req || param[0] == :opt }.map { |param| param[1] }
    key_params = params.select { |param| param[0] == :keyreq }.map { |param| param[1] }

    [pos_params, key_params]
  end

  def pluralize(item)
    item = item.to_s
    return item if item.end_with?('s')

    return "#{item}es" if item.end_with?('ch') || item.end_with?('sh') || item.end_with?('x') || item.end_with?('z')
    return "#{item[0..-2]}ies" if item.end_with?('y')

    "#{item}s".to_sym
  end
end
