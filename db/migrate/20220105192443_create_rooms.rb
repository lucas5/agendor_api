class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.references :office, foreign_key: { to_table: :offices }
      t.string :name
      t.timestamps
    end

    # Create office and rooms
    office = Office.create(name: 'GetNinjas')
    Room.create(office_id: office.id, name: 'Sala 1')
    Room.create(office_id: office.id, name: 'Sala 2')
    Room.create(office_id: office.id, name: 'Sala 3')
    Room.create(office_id: office.id, name: 'Sala 4')
  end
end
