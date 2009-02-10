require "methopara"

module GetArgs
  def get_args
    unless respond_to?(:parameters)
      raise NotImplementedError, "Ruby #{RUBY_VERSION} doesn't support #{self.class}#parameters"
    end

    required = []
    optional = []

    parameters.each do |(type, name)|
      if type == :opt
        required << [name, nil]
        optional << name
      else
        required << [name]
      end
    end

    return [required, optional]
  end
end
