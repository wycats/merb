require "digest/sha1"
class Authentication
  module Mixins
    # This mixin provides basic salted user password encryption.
    # 
    # Added properties:
    #  :crypted_password, String
    #  :salt,             String
    #
    # To use it simply require it and include it into your user class.
    #
    # class User
    #   include Authentication::Mixins::SaltedUser
    #
    # end
    #
    module SaltedUser
      
      def self.included(base)
        base.class_eval do 
          attr_accessor :password, :password_confirmation
          
          include Authentication::Mixins::SaltedUser::InstanceMethods
          extend  Authentication::Mixins::SaltedUser::ClassMethods
          
          path = File.expand_path(File.dirname(__FILE__)) / "salted_user"
          if defined?(DataMapper) && DataMapper::Resource > self
            require path / "dm_salted_user"
            extend(Authentication::Mixins::SaltedUser::DMClassMethods)
          elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
            require path / "ar_salted_user"
            extend(Authentication::Mixins::SaltedUser::ARClassMethods)
          elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
            require path / "sq_salted_user"
            extend(Authentication::Mixins::SaltedUser::SQClassMethods)
          end
          
        end # base.class_eval
      end # self.included
      
      
      module ClassMethods
        # Encrypts some data with the salt.
        def encrypt(password, salt)
          Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        end
      end    
      
      module InstanceMethods
        def authenticated?(password)
          crypted_password == encrypt(password)
        end
        
        def encrypt(password)
          self.class.encrypt(password, salt)
        end
        
        def password_required?
          crypted_password.blank? || !password.blank?
        end
        
        def encrypt_password
          return if password.blank?
          self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Authentication::Strategies::Basic::Base.login_param}--") if new_record?
          self.crypted_password = encrypt(password)
        end
        
      end # InstanceMethods
      
    end # SaltedUser    
  end # Mixins
end # Authentication

