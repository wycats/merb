require 'net/http'
require 'uri'
require "erb"

module MerbExceptions
  class Notification
    attr_reader :details

    def initialize(details = nil)
      @details = details || {}
      @config = Merb::Plugins.config[:exceptions]
    end

    def deliver!
      deliver_web_hooks!
      deliver_emails!
    end

    def deliver_web_hooks!
      return unless should_deliver_notifications?
      Merb.logger.info "DELIVERING EXCEPTION WEB HOOKS"
      web_hooks.each do |address|
        post_hook(address)
      end
    end

    def deliver_emails!
      return unless should_deliver_notifications?
      Merb.logger.info  "DELIVERING EXCEPTION EMAILS"
      email_addresses.each do |address|
        send_notification_email(address)
      end
    end

    def web_hooks; option_as_array(:web_hooks); end

    def email_addresses; option_as_array(:email_addresses); end

    def environments; option_as_array(:environments); end


    def should_deliver_notifications?
      environments.include? Merb.env
    end


    def params
      {
        'request_url'              => details['url'],
        'request_controller'       => details['params'][:controller],
        'request_action'           => details['params'][:action],
        'request_params'           => details['params'],
        'environment'              => details['environment'],
        'exceptions'               => details['exceptions'],
        'app_name'                 => @config[:app_name]
      }
    end

  private

    def post_hook(address)
      Merb.logger.info "- hooking to #{address}"
      uri = URI.parse(address)
      uri.path = '/' if uri.path=='' # set a path if one isn't provided to keep Net::HTTP happy
      Net::HTTP.post_form( uri, params ).body
    end

    def send_email(address, body)
      Merb.logger.info "- emailing to #{address}"
      email = Merb::Mailer.new({
        :to => address,
        :from => @config[:email_from],
        :subject => "[#{@config[:app_name]} EXCEPTION]",
        :text => body
      })
      email.deliver!
    end

    def send_notification_email(address)
      send_email(address, plain_text_mail_body)
    end

    def plain_text_mail_body
      path = File.join(File.dirname(__FILE__), 'templates', 'email.erb')
      template = Erubis::Eruby.new(File.open(path,'r') { |f| f.read })
      template.result(binding)
    end

    # Used so that we can accept either a single value or array (e.g. of
    # webhooks) in our YAML file.
    def option_as_array(option)
      value = @config[option]
      case value
      when Array
        value.reject { |e| e.nil? } # Don't accept nil values
      when String
        [value]
      else
        []
      end
    end
  end
end
