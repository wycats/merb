class <%= class_name %>
  include DataMapper::Resource
  <% attributes.each do |name, type| %>
  property :<%= name %>, <%= type.camel_case %>
  <% end %>
end