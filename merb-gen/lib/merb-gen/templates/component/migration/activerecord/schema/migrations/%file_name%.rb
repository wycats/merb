class <%= class_name %> < ActiveRecord::Migration
  def self.up
<% if model -%>
    create_table :<%= table_name %> do |t|
<% attributes.each do |name, type| -%>
      t.<%= name %> :<%= type %> 
<% end -%>
  
      t.timestamps
    end
<% end -%> 
  end

  def self.down
<% if model -%>
    drop_table :<%= table_name %>
<% end -%>
  end
end
