module Merb::Generators
  
  class SliceGenerator < Generator
    
    option :thin, :as => :boolean, :desc => 'Generates a thin slice'
    option :very_thin, :as => :boolean, :desc => 'Generates an even thinner slice'
    
    desc <<-DESC
      Generates a merb slice.
    DESC
    
    first_argument :name, :required => true
    
    invoke :full_slice, :thin => nil, :very_thin => nil
    invoke :thin_slice, :thin => true
    invoke :very_thin_slice, :very_thin => true
    
  end
  
  class BaseSliceGenerator < NamedGenerator
    
    def self.common_template(name, source)
      template name do 
        source File.dirname(__FILE__), 'templates', 'common', source
        destination source
      end
    end
    
  end
  
  add :slice, SliceGenerator
  
end