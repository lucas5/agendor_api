class Office < ApplicationRecord
  has_many :rooms, class_name: 'Room'
end
