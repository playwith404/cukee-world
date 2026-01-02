class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :company
      t.string :inquiry_type, default: "general"
      t.text :message, null: false
      t.string :status, default: "pending"

      t.timestamps
    end

    add_index :contacts, :email
    add_index :contacts, :created_at
    add_index :contacts, :status
  end
end
