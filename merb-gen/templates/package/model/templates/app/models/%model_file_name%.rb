class <%= model_class_name %>
<% unless model_attributes.empty? -%>
  attr_accessor <%= model_attributes.map{|a| ":#{a.first}" }.compact.uniq.join(", ") %>
<% end -%>
end