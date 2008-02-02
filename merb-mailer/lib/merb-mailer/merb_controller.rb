class Merb::Controller
  # Sends mail via a MailController (a tutorial can be found in the
  # MailController docs).
  # 
  #  send_mail FooMailer, :bar, :from => "foo@bar.com", :to => "baz@bat.com"
  # 
  # would send an email via the FooMailer's bar method.
  # 
  # The mail_params hash would be sent to the mailer, and includes items
  # like from, to subject, and cc. See
  # Merb::MailController#dispatch_and_deliver for more details.
  # 
  # The send_params hash would be sent to the MailController, and is
  # available to methods in the MailController as <tt>params</tt>. If you do
  # not send any send_params, this controller's params will be available to
  # the MailController as <tt>params</tt>
  def send_mail(klass, method, mail_params, send_params = nil)
    klass.new(send_params || params, self).dispatch_and_deliver(method, mail_params)
  end
end