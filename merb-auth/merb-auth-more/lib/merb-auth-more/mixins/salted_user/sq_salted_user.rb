require 'merb_sequel'

class Merb::Authentication
  module Mixins
    module SaltedUser

      module SQ3Hooks
        def before_save
          return false if super == false
          encrypt_password
        end
      end

      module SQ3Validations
        def validate
          validates_presence(:password) if password_required?
          validates_presence(:password_confirmation) if password_required?
          errors.add(:password, "Passwords are not the same") if password != password_confirmation
        end
      end

      module SQInstanceMethods
        unless Sequel::Model.instance_methods.include?(:new_record?)
          def new_record?
            self.new?
          end
        end

        if Merb::Orms::Sequel.new_sequel?
          include Merb::Authentication::Mixins::SaltedUser::SQ3Hooks
          include Merb::Authentication::Mixins::SaltedUser::SQ3Validations
        end
      end

      module SQClassMethods
        def self.extended(base)
          base.class_eval do
            unless Merb::Orms::Sequel.new_sequel?
              before_save :encrypt_password
              validates_presence_of     :password,                   :if => :password_required?
              validates_presence_of     :password_confirmation,      :if => :password_required?
              validates_confirmation_of :password,                   :if => :password_required?
            end
            include Merb::Authentication::Mixins::SaltedUser::SQInstanceMethods 
          end
        end # self.extended
        
        def authenticate(login, password)
          @u = find(Merb::Authentication::Strategies::Basic::Base.login_param => login)
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # SQClassMethods

    end # SaltedUser
  end # Mixins
end # Merb::Authentication 
