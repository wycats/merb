class LazyArray  # borrowed partially from StrokeDB
  instance_methods.each { |m| undef_method m unless %w[ __id__ __send__ send dup class object_id kind_of? respond_to? assert_kind_of should should_not instance_variable_set instance_variable_get extend ].include?(m.to_s) }

  include Enumerable

  # these methods should return self or nil
  RETURN_SELF = [ :<<, :clear, :concat, :collect!, :each, :each_index,
    :each_with_index, :freeze, :insert, :map!, :push, :replace,
    :reject!, :reverse!, :reverse_each, :sort!, :unshift ]

  RETURN_SELF.each do |method|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{method}(*args, &block)
        lazy_load
        results = @array.#{method}(*args, &block)
        results.kind_of?(Array) ? self : results
      end
    EOS
  end

  (Array.public_instance_methods(false).map { |m| m.to_sym } - RETURN_SELF - [ :taguri= ]).each do |method|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{method}(*args, &block)
        lazy_load
        @array.#{method}(*args, &block)
      end
    EOS
  end

  def replace(other)
    mark_loaded
    @array.replace(other.entries)
    self
  end

  def clear
    mark_loaded
    @array.clear
    self
  end

  def eql?(other)
    lazy_load
    @array.eql?(other.entries)
  end

  alias == eql?

  def load_with(&block)
    @load_with_proc = block
    self
  end

  def loaded?
    @loaded == true
  end

  def unload
    clear
    @loaded = false
    self
  end

  def respond_to?(method, include_private = false)
    super || @array.respond_to?(method, include_private)
  end

  def to_proc
    @load_with_proc
  end

  private

  def initialize(*args, &block)
    @loaded         = false
    @load_with_proc = proc { |v| v }
    @array          = Array.new(*args, &block)
  end

  def initialize_copy(original)
    @array = original.entries
    load_with(&original)
    mark_loaded if @array.any?
  end

  def lazy_load
    return if loaded?
    mark_loaded
    @load_with_proc[self]
  end

  def mark_loaded
    @loaded = true
  end

  # delegate any not-explicitly-handled methods to @array, if possible.
  # this is handy for handling methods mixed-into Array like group_by
  def method_missing(method, *args, &block)
    if @array.respond_to?(method)
      lazy_load
      @array.send(method, *args, &block)
    else
      super
    end
  end
end
