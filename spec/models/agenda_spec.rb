require "rails_helper"

RSpec.describe Agenda, type: :model do
  let(:office) { create(:office, name: 'GetNinjas', capacity: 4) }
  let(:room) { create(:room, office_id: @office.id, name: 'Sala 1') }
  let(:agenda) { create(:agenda, office_id: office.id, room_id: room.id) }
end
