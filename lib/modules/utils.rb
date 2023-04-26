module Utils
  private

  # Convert hash to class instance
  # This method will work well if the class don't convert during initialization
  # klass - Class object
  # hash - Hash object
  def class_from_hash(klass, hash)
    params = get_parameters(klass)
    pos_params = params.select { |param| param[0] == :req || param[0] == :opt }.map { |param| param[1] }
    key_params = params.select { |param| param[0] == :key }.map { |param| param[1] }

    pos_params = pos_params.map { |param| hash[param] }
    key_params = hash.select { |key, _| key_params.include?(key) }

    instance = klass.new(*pos_params, **key_params)
    hash.each do |key, value|
      instance.instance_variable_set("@#{key}", value)
    end

    instance.instance_variable_set(:@items, []) if instance.respond_to?(:items)
    instance
  end

  def get_parameters(klass)
    klass.instance_method(:initialize).parameters
  end
end
