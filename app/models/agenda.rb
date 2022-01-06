class Agenda < ApplicationRecord
  belongs_to :office, class_name: 'Office'
  belongs_to :room, class_name: 'Room'

  before_create :generate_token
  after_save :reserve_amount_of_hours

  validate :valid_time
  validate :valid_date_and_time
  validate :already_reserved

  def already_reserved
    return if id.present? && start_time_in_database == start_time && reserve_date_in_database == reserve_date

    agenda = Agenda.find_by(room_id: room_id, start_time: start_time, reserve_date: reserve_date)
    errors.add(:details, { message: 'Horário já reservado.' }) if agenda.present?
  end

  def self.agenda_list(room_id, reserve_date)
    agendas = Agenda.where(room_id: room_id, reserve_date: reserve_date).order(:start_time).pluck(:token).uniq
    list = []
    agendas.map do |token|
      agenda = Agenda.where(token: token).order(:start_time)
      start_time = agenda.first.start_time
      end_time = agenda.last.start_time
      list.push("Reserva de #{agenda.first.reserve_name} das #{start_time}:00 hrs até #{end_time + 1}:00 hrs")
    end
    list
  end

  def valid_date_and_time
    if reserve_date < Date.current
      errors.add(:details, { message: 'A data de reserva já passou.' })
    elsif reserve_date == Date.current && start_time < Time.current.hour
      errors.add(:details, { message: 'A hórario de reserva já passou.' })
    end
  end

  def valid_time
    if start_time < 9 || (start_time + amount_of_hours) > 18
      errors.add(:details, { message: 'O horário escolhido não está disponível para reserva.' })
    end
  end

  def not_weekend
    errors.add(:details, { message: 'As reservas só podem ser feitas nos dias úteis.' }) if reserve_date.on_weekend?
  end

  def reserve_amount_of_hours
    Agenda.where(token: token).where.not(start_time: start_time).destroy_all if id.present? && amount_of_hours > 1
    1.upto(amount_of_hours - 1) do |hour|
      new_reserve = dup
      new_reserve.amount_of_hours = 1
      new_reserve.start_time = start_time + hour
      new_reserve.save(validate: false)
    end
  end

  def self.find_reserves(token)
    Agenda.joins(room: [:office])
          .select("agendas.id, amount_of_hours, token, reserve_name, start_time, reserve_date, rooms.name as room_name, offices.name as office_name")
          .where(token: token).order(:start_time)
  end

  def self.available_times(date = Date.current, room)
    available_hours = []
    9.upto(17) do |hour|
      available = Agenda.where(reserve_date: date, room_id: room.id, office_id: room.office_id)
                        .find_by(start_time: hour)

      next if available.present?

      available_hours.push("#{hour}:00 às #{hour + 1}:00") unless date.to_date == Date.current && hour < Time.current.hour
    end
    available_hours
  end

  protected

  def generate_token
    return if token.present?

    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(5, false)
      break random_token unless Agenda.exists?(token: random_token)
    end
  end
end
