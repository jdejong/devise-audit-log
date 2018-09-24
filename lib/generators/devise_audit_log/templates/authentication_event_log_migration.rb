class <%= migration_class_name %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :authentication_event_logs do |t|
      t.string :scope
      t.string :strategy
      t.string :identity
      t.references :user, polymorphic: true
      t.string :event_type

      t.boolean :success
      t.string :failure_reason

      t.string :action
      t.string :ip
      t.text :user_agent
      t.text :referrer

      t.timestamps
    end

    add_index :authentication_event_logs, :identity
    add_index :authentication_event_logs, :ip
  end
end