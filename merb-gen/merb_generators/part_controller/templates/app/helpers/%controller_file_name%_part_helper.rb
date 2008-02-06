<% counter = 1 -%>
module Merb
<% controller_modules.each_with_index do |mod, i| -%>
<%= "  " * i %>module <%= mod %>
<% counter = i -%>
<% end -%>
<% counter = counter == 0 ? 0 : (counter + 1) -%>
<%= "  " * counter %>module <%= controller_class_name %>PartHelper

<%= "  " * counter %>end
<% counter = counter == 0 ? 0 : (counter - 1) -%>
<% controller_modules.reverse.each_with_index do |mod, i| -%>
<%= "  " * counter %>end # <%= mod %>
<% counter = counter - 1 -%>
<% end -%>
end