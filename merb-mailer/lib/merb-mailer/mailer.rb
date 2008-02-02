begin
  require 'mailfactory'
  require 'net/smtp'
rescue LoadError
  puts "You need to install the mailfactory gem to use Merb::Mailer"
  Merb.logger.warn "You need to install the mailfactory gem to use Merb::Mailer"
end  

class MailFactory
  attr_reader :html, :text
end

module Merb

  # You'll need a simple config like this in merb_init.rb if you want
  # to actually send mail:
  #
  #   Merb::Mailer.config = {
  #     :host=>'smtp.yourserver.com',
  #     :port=>'25',              
  #     :user=>'user',
  #     :pass=>'pass',
  #     :auth=>:plain # :plain, :login, :cram_md5, the default is no auth
  #   }
  # 
 	#   or 
 	# 
 	#   Merb::Mailer.config = {:sendmail_path => '/somewhere/odd'}
  #   Merb::Mailer.delivery_method = :sendmail
  #
  # You could send mail manually like this (but it's better to use
  # a MailController instead).
  # 
  #   m = Merb::Mailer.new :to => 'foo@bar.com',
  #                        :from => 'bar@foo.com',
  #                        :subject => 'Welcome to whatever!',
  #                        :body => partial(:sometemplate)
  #   m.deliver!                     

  class Mailer
    
    class_inheritable_accessor :config, :delivery_method, :deliveries
    attr_accessor :mail
    self.deliveries = []
    
    def sendmail
      sendmail = IO.popen("#{config[:sendmail_path]} #{@mail.to}", 'w+') 
      sendmail.puts @mail.to_s
      sendmail.close
    end
  
    # :plain, :login, or :cram_md5
    def net_smtp
      Net::SMTP.start(config[:host], config[:port].to_i, config[:domain], 
                      config[:user], config[:pass], config[:auth]) { |smtp|
        smtp.send_message(@mail.to_s, @mail.from.first, @mail.to.to_s.split(/[,;]/))
      }
    end
    
    def test_send
      deliveries << @mail
    end
    
    def deliver!
      send(delivery_method || :net_smtp)
    end
      
    def attach(file_or_files, filename = file_or_files.is_a?(File) ? File.basename(file_or_files.path) : nil, 
      type = nil, headers = nil)
      if file_or_files.is_a?(Array)
        file_or_files.each {|k,v| @mail.add_attachment_as k, *v}
      else
        raise ArgumentError, "You did not pass in a file. Instead, you sent a #{file_or_files.class}" if !file_or_files.is_a?(File)
        @mail.add_attachment_as(file_or_files, filename, type, headers)
      end
    end
      
    def initialize(o={})
      self.config = {:sendmail_path => '/usr/sbin/sendmail'} if config.nil? 
      o[:rawhtml] = o.delete(:html)
      m = MailFactory.new()
      o.each { |k,v| m.send "#{k}=", v }
      @mail = m
    end
    
  end
end
