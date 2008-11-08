class Module
  def find_const(const_name)
    if const_name[0..1] == '::'
      Object.find_const(const_name[2..-1])
    else
      nested_const_lookup(const_name)
    end
  end
  
  def try_dup
    self
  end

  private

  # Doesn't do any caching since constants can change with remove_const
  def nested_const_lookup(const_name)
    constants = [ Object ]

    unless self == Object
      self.name.split('::').each do |part|
        constants.unshift(constants.first.const_get(part))
      end
    end

    parts = const_name.split('::')

    # from most to least specific constant, use each as a base and try
    # to find a constant with the name const_name within them
    constants.each do |const|
      # return the nested constant if available
      return const if parts.all? do |part|
        const = const.const_defined?(part) ? const.const_get(part) : nil
      end
    end

    # if we get this far then the nested constant was not found
    raise NameError, "uninitialized constant #{const_name}"
  end

end # class Module
