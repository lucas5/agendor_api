class Office < ApplicationRecord
  has_many :rooms, class_name: 'Room'
  has_many :agendas, class_name: 'Agenda'
end
