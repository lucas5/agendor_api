class CreateOffices < ActiveRecord::Migration[6.0]
  def change
    create_table :offices do |t|
      t.integer :capacity, default: 4
      t.string :name
      t.timestamps
    end
  end
end
