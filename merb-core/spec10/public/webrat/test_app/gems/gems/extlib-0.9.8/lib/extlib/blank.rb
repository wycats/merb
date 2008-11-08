class Object
  # @return <TrueClass, FalseClass>
  #
  # @example [].blank?         #=>  true
  # @example [1].blank?        #=>  false
  # @example [nil].blank?      #=>  false
  # 
  # Returns true if the object is nil or empty (if applicable)
  def blank?
    nil? || (respond_to?(:empty?) && empty?)
  end
end # class Object

class Numeric
  # @return <TrueClass, FalseClass>
  # 
  # Numerics can't be blank
  def blank?
    false
  end
end # class Numeric

class NilClass
  # @return <TrueClass, FalseClass>
  # 
  # Nils are always blank
  def blank?
    true
  end
end # class NilClass

class TrueClass
  # @return <TrueClass, FalseClass>
  # 
  # True is not blank.  
  def blank?
    false
  end
end # class TrueClass

class FalseClass
  # False is always blank.
  def blank?
    true
  end
end # class FalseClass

class String
  # @example "".blank?         #=>  true
  # @example "     ".blank?    #=>  true
  # @example " hey ho ".blank? #=>  false
  # 
  # @return <TrueClass, FalseClass>
  # 
  # Strips out whitespace then tests if the string is empty.
  def blank?
    strip.empty?
  end
end # class String
