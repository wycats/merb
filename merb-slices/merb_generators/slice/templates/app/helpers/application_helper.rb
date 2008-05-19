module Merb
  module <%= module_name %>
    module ApplicationHelper
      
      def image_path(*segments)
        public_path_for(:image, *segments)
      end
      
      def javascript_path(*segments)
        public_path_for(:javascript, *segments)
      end
      
      def stylesheet_path(*segments)
        public_path_for(:stylesheet, *segments)
      end
      
      def public_path_for(type, *segments)
        File.join(::<%= module_name %>.public_dir_for(type), *segments)
      end
      
      def app_path_for(type, *segments)
        File.join(::<%= module_name %>.app_dir_for(type), *segments)
      end
      
      def slice_path_for(type, *segments)
        File.join(::<%= module_name %>.dir_for(type), *segments)
      end
      
    end
  end
end