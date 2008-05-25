module Merb
  
  module ComponentGenerators
    
    class ModelGenerator < ComponentGenerator
      
      first_argument :name
      second_argument :attributes, :as => :hash
      
      template :model do
        source('model.rbt')
        destination('app/models/' + file_name + '.rb')
      end
      
      def class_name
        
      end
      
      def file_name
        
      end
      
      def attributes?
        self.attributes && !self.attributes.empty?
      end
      
      def attributes_for_accessor
        self.attributes.map{|a| ":#{a.first}" }.compact.uniq.join(", ")
      end
      
      def source_root
        File.join(super, 'model')
      end
      
    end
    
    add :model, ModelGenerator
    
  end
  
end