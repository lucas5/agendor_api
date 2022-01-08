class Room < ApplicationRecord
  belongs_to :office, class_name: 'Office'
  has_many :agendas, class_name: 'Agenda'

  validate :capacity_verify

  # Check if the office still has the capacity to have registered rooms
  def capacity_verify
    office = Office.find_by(id: office_id)
    office_capacity = Room.where(office_id: office&.id).count
    if office.present? && (office_capacity >= office.capacity)
      errors.add(:details, { message: 'Your office capacity is full' })
    end
  end
end
