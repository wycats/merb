require 'bcrypt'
require 'merb-auth-more/strategies/abstract_password'

class Merb::Authentication
  module Mixins
    # This mixin provides basic salted user password encryption.
    # 
    # Added properties:
    #  :crypted_password, String
    #
    # To use it simply require it and include it into your user class.
    #
    # class User
    #   include Merb::Authentication::Mixins::SaltedUser
    #
    # end
    #
    module BCryptUser
      
      def self.included(base)
        base.class_eval do 
          attr_accessor :password, :password_confirmation

          
          include Merb::Authentication::Mixins::BCryptUser::InstanceMethods

          
          path = File.expand_path(File.dirname(__FILE__)) / "salted_user"
          if defined?(DataMapper) && DataMapper::Resource > self
            require path / "dm_salted_user"
            extend(Merb::Authentication::Mixins::SaltedUser::DMClassMethods)
          elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
            require path / "ar_salted_user"
            extend(Merb::Authentication::Mixins::SaltedUser::ARClassMethods)
          elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
            require path / "sq_salted_user"
            extend(Merb::Authentication::Mixins::SaltedUser::SQClassMethods)
          elsif defined?(RelaxDB) && ancestors.include?(RelaxDB::Document)
            require path / "relaxdb_salted_user"
            extend(Merb::Authentication::Mixins::SaltedUser::RDBClassMethods)
          end
          
        end # base.class_eval
      end # self.included
      
      
      module InstanceMethods
        
        def authenticated?(password)
          bcrypt_password == password
        end
        
        def bcrypt_password
          @bcrypt_password ||=  BCrypt::Password.new(crypted_password)
        end
        
        def password_required?
          crypted_password.blank? || !password.blank?
        end
        
        def encrypt_password
          return if password.blank?
          cost =  Merb::Plugins.config[:"merb-auth"][:bcrypt_cost] || BCrypt::Engine::DEFAULT_COST
          self.crypted_password =  BCrypt::Password.create(password, :cost => cost)
        end
        
      end # InstanceMethods
      
    end # SaltedUser    
  end # Mixins
end # Merb::Authentication

