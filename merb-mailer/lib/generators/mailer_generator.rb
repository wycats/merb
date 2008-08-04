module Merb::Generators
  class MailerGenerator < ComponentGenerator
 
    def self.source_root
      File.dirname(__FILE__) / '..' / '..' / 'templates' / 'mailer'
    end
    
    desc <<-DESC
      Generates a mailer
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: spec, test_unit)'
    
    first_argument :name, :required => true, :desc => "mailer name"
    
    template :mailer do
      source('app/mailers/%file_name%_mailer.rb')
      destination("app/mailers/#{file_name}_mailer.rb")
    end
    
    template :notify_on_event do
      source('app/mailers/views/%file_name%_mailer/notify_on_event.text.erb')
      destination("app/mailers/views/#{file_name}_mailer/notify_on_event.text.erb")
    end
    
    template :controller_spec, :testing_framework => :rspec do
      source('spec/mailers/%file_name%_mailer_spec.rb')
      destination("spec/mailers/#{file_name}_mailer_spec.rb")
    end
    
    def modules
      chunks[0..-2]
    end
    
    def class_name
      chunks.last
    end
    
    def full_class_name
      chunks.join('::')
    end
    
    def test_class_name
      controller_class_name + "Test"
    end
    
    def file_name
      controller_class_name.snake_case
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
 
  end
 
  add :mailer, MailerGenerator
end