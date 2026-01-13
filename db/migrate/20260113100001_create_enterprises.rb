class CreateEnterprises < ActiveRecord::Migration[8.1]
  def change
    create_table :enterprises do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :company_registration_number
      t.string :contact_name
      t.string :contact_phone
      t.string :plan_type, default: "starter"
      t.decimal :monthly_limit, precision: 10, scale: 2, default: 0
      t.decimal :current_usage, precision: 10, scale: 2, default: 0
      t.date :billing_cycle_start
      t.string :status, default: "active"
      t.text :notes

      t.timestamps
    end

    add_index :enterprises, :email, unique: true
    add_index :enterprises, :plan_type
    add_index :enterprises, :status
  end
end
