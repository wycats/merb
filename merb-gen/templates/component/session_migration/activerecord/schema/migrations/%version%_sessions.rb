class DatabaseSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.column :session_id, :text
      t.column :data,       :text
    end
  end

  def self.down
    drop_table :sessions
  end
end