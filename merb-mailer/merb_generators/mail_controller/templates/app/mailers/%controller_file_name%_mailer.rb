<% counter = 0 -%>
<% controller_modules.each_with_index do |mod, i| -%>
<%= "  " * i %>module <%= mod %>
<% counter = i -%>
<% end -%>
<% counter = counter == 0 ? 0 : (counter + 1) -%>
<%= "  " * counter %>class <%= controller_class_name %>Mailer < Merb::MailController
  
<%= "  " * counter %>  def notify_on_event
<%= "  " * counter %>    # use params[] passed to this controller to get data
<%= "  " * counter %>    # read more at http://wiki.merbivore.com/pages/mailers
<%= "  " * counter %>    render_mail
<%= "  " * counter %>  end
  
<%= "  " * counter %>end
<% counter = counter == 0 ? 0 : (counter - 1) -%>
<% controller_modules.reverse.each_with_index do |mod, i| -%>
<%= "  " * counter %>end # <%= mod %>
<% counter = counter - 1 -%>
<% end -%>