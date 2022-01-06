class CreateAgendas < ActiveRecord::Migration[6.0]
  def change
    create_table :agendas do |t|
      t.references :room, foreign_key: { to_table: :rooms }
      t.references :office, foreign_key: { to_table: :offices }
      t.integer :start_time, null: false
      t.integer :amount_of_hours, default: 1
      t.date :reserve_date, null: false
      t.string :reserve_name, null: false
      t.string :token
      t.timestamps
    end
  end
end
