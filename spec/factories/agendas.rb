# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :agenda do
    association :office
    association :room
    start_time { 9 }
    amount_of_hours { 1 }
    reserve_date { "10/01/2023".to_date }
    reserve_name { 'User 1' }
  end

  trait :with_room do
    before(:create) do |agenda|
      office = create(:office, name: 'GetNinjas', capacity: 4)
      room = create(:room, office_id: office.id, name: 'Sala 1')
      agenda.office_id = office.id
      agenda.room_id = room.id
    end
  end
end
