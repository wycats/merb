module Merb
  
  # Sending mail from a controller involves three steps:
  #
  # * Set mail settings in merb_init.rb (Not shown here...see the Mailer docs).
  # * Create a MailController subclass with actions and templates.
  # * Call the MailController from another Controller via the send_mail method.
  #
  # First, create a file in app/mailers that subclasses Merb::MailController. 
  # The actions in this controller will do nothing but render mail.
  #
  #   # app/mailers/article_mailer.rb
  #   class ArticleMailer < Merb::MailController
  # 
  #     def notify
  #       @user = params[:user]
  #       render_mail
  #     end
  # 
  #   end
  #
  # You also can access the params hash for values passed with the 
  # Controller.send_mail method. See also the documentation for 
  # render_mail to see all the ways it can be called.
  #
  # Create a template in a subdirectory of app/mailers/views that corresponds
  # to the controller and action name. Put plain text and ERB tags here:
  #
  #   # app/mailers/views/article_mailer/notify.text.erb
  #   Hey, <%= @user.name %>,
  #   
  #   We're running a sale on dog bones!
  #
  # Finally, call the Controller.send_mail method from a standard 
  # Merb controller.
  #
  #   class Articles < Application
  #
  #     def index
  #       @user = User.find_by_name('louie')
  #
  #       send_mail(ArticleMailer, :notify, {
  #         :from => "me@example.com",
  #         :to => "louie@example.com",
  #         :subject => "Sale on Dog Bones!"
  #       }, { :user => @user })
  #       render
  #     end
  #
  #   end  
  #
  # Note: If you don't pass a fourth argument to Controller.send_mail,
  # the controller's params will be sent to the MailController subclass
  # as params. However, you can explicitly send a hash of objects that 
  # will populate the params hash instead. In either case, you must 
  # set instance variables in the MailController's actions if you 
  # want to use them in the MailController's views.
  #
  # The MailController class is very powerful. You can:
  #
  # * Send multipart email with a single call to render_mail.
  # * Attach files.
  # * Render layouts and other templates.
  # * Use any template engine supported by Merb.
  
  class MailController < AbstractController
   
    class_inheritable_accessor :_mailer_klass
    self._mailer_klass  = Merb::Mailer
    
    attr_accessor :params, :mailer, :mail
    attr_reader   :session, :base_controller
    
    def _template_location(action, type = nil, controller = controller_name)
      "#{controller}/#{action}.#{type}"
    end
    
    # You can initialize a MailController with a series of parameters that can
    # be used by methods in the class. You can also pass in a controller
    # object, which will be available to the MailController methods as
    # base_controller.
    def initialize(params = {}, controller = nil)
      @params = params
      @base_controller = controller
      @session = (controller && controller.session) || {}
      super
    end
    
    def self.inherited(klass)
      klass.class_eval %{self._template_root = Merb.dir_for(:mailer) / "views"}
      super
    end
    
    def filters_halted
    end
    
    # Allows you to render various types of things into the text and HTML parts
    # of an email If you include just text, the email will be sent as
    # plain-text. If you include HTML, the email will be sent as a multi-part
    # email.
    #
    # There are a lot of ways to use render_mail, but it works similarly to the
    # default Merb render method.
    #
    # First of all, you'll need to store email files in your
    # app/mailers/views directory. They should be under a directory that
    # matches the name of your mailer (e.g. TestMailer's views would be stored
    # under test_mailer).
    #
    # The files themselves should be named action_name.mime_type.extension. For
    # example, an erb template that should be the HTML part of the email, and
    # rendered from the "foo" action would be named foo.html.erb.
    #
    # The only mime-types currently supported are "html" and "text", which
    # correspond to text/html and text/plain respectively. All template systems
    # supported by your app are available to MailController, and the extensions
    # are the same as they are throughout the rest of Merb.
    #
    # render_mail can take any of the following option patterns:
    #
    #   render_mail
    #
    # will attempt to render the current action. If the current action is
    # "foo", this is identical to render_mail :foo.
    #
    #   render_mail :foo
    # 
    # checks for foo.html.ext and foo.text.ext and applies them as appropriate.
    #
    #   render_mail :action => {:html => :foo, :text => :bar}
    #
    # checks for foo.html.ext and bar.text.ext in the view directory of the
    # current controller and adds them to the mail object if found
    #
    #   render_mail :template => {:html => "foo/bar", :text => "foo/baz"}
    #
    # checks for bar.html.ext and baz.text.ext in the foo directory and adds
    # them to the mail object if found.
    #
    #   render_mail :html => :foo, :text => :bar
    #
    # the same as render_mail :action => {html => :foo, :text => :bar }
    #
    #   render_mail :html => "FOO", :text => "BAR"
    #
    # adds the text "FOO" as the html part of the email and the text "BAR" as
    # the text part of the email. The difference between the last two examples
    # is that symbols represent actions to render, while string represent the
    # literal text to render. Note that you can use regular render methods
    # instead of literal strings here, like:
    #
    #   render_mail :html => render(:action => :foo)
    #
    # but you're probably better off just using render_mail :action at that
    # point.
    #
    # You can also mix and match:
    #
    #   render_mail :action => {:html => :foo}, :text => "BAR"
    #
    # which would be identical to:
    #
    #   render_mail :html => :foo, :text => "BAR"
    def render_mail(options = @method)
      @_missing_templates = false # used to make sure that at least one template was found
      # # If the options are not a hash, normalize to an action hash
      options = {:action => {:html => options, :text => options}} if !options.is_a?(Hash)
      
      # Take care of the options
      opts_hash = {}
      opts = options.dup
      actions = opts.delete(:action) if opts[:action].is_a?(Hash)
      templates = opts.delete(:template) if opts[:template].is_a?(Hash)
      
      # Prepare the options hash for each format
      # We need to delete anything relating to the other format here
      # before we try to render the template.
      [:html, :text].each do |fmt|
        opts_hash[fmt] = opts.delete(fmt)
        opts_hash[fmt] ||= actions[fmt] if actions && actions[fmt]
        opts_hash[:template] = templates[fmt] if templates && templates[fmt]
      end

      # require 'ruby-debug'
      # debugger if $DEBUGGER
            
      # Send the result to the mailer
      { :html => "rawhtml=", :text => "text="}.each do |fmt,meth|
        begin
          local_opts = opts.merge(:format => fmt)
          local_opts.merge!(:layout => false) if opts_hash[fmt].is_a?(String)
          
          value = render opts_hash[fmt], local_opts
          @mail.send(meth,value) unless value.nil? || value.empty?
        rescue => e
          # An error should be logged if no template is found instead of an error raised
          if @_missing_templates
            Merb.logger.error(e)
          else
            @_missing_templates = true
          end
        end
      end
      @mail
    end
    
    # Attaches a file or multiple files to an email. You call this from a
    # method in your MailController (including a before filter).
    # 
    #   attach File.open("foo")
    #   attach [File.open("foo"), File.open("bar")]
    # 
    # You can also include the filename, mime-type, or headers in the
    # subsequent parameters.
    # 
    # If you are passing an array of files, you should use an array of the
    # allowed parameters:
    # 
    #   attach [[File.open("foo"), "bar", "text/html"], [File.open("baz"),
    # "bat", "text/css"]
    # 
    #  which would attach two files ("foo" and "baz" in the filesystem) as
    # "bar" and "bat" respectively. It would also set the mime-type as
    # "text/html" and "text/css" respectively.
    def attach( file_or_files, filename = file_or_files.is_a?(File) ? File.basename(file_or_files.path) : nil, 
      type = nil, headers = nil)
      @mailer.attach(file_or_files, filename, type, headers)
    end
    
    # take a method name to dispatch to and mail parameters for the MailFactory object.
    #
    # Available mail parameters include:
    #   to
    #   from
    #   replyto
    #   subject
    #   body
    #   cc
    #
    # Other parameters passed in will be interpreted as email headers, with _'s converted
    # to -'s.
    def dispatch_and_deliver(method, mail_params)
      @mailer         = self.class._mailer_klass.new(mail_params)
      @mail           = @mailer.mail
      @method         = method
      
      # dispatch and render use params[:action], so set it
      self.action_name = method

      body             = _dispatch method
      if !@mail.html.blank? || !@mail.text.blank?
        @mailer.deliver!
        Merb.logger.info "#{method} sent to #{@mail.to} about #{@mail.subject}"
      else
        Merb.logger.info "#{method} was not sent because nothing was rendered for it"
      end
    end

    # A convenience method that creates a blank copy of the MailController and runs
    # dispatch_and_deliver on it.
    def self.dispatch_and_deliver(method, mail_params, send_params = {})
      new(send_params).dispatch_and_deliver method, mail_params
    end
    
    protected
    def route
      @base_controller.route if @base_controller
    end

    private
    # This method is here to overwrite the one in the general_controller mixin
    # The method ensures that when a url is generated with a hash, it contains a controller
    def get_controller_for_url_generation(opts)
      controller = opts[:controller] || ( @base_controller.params[:controller] if @base_controller)
       raise "No Controller Specified for url()" unless controller
       controller
    end
    
    
  end
end