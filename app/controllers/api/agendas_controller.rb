module Api
  class AgendasController < ApiController
    before_action :load_room, only: %i[available_times new create]

    def available_times
      available_times = Agenda.available_times(params[:date], @room)
      render json: { status: :ok, payload: available_times }
    end

    def agenda_list
      @agendas = Agenda.agenda_list(params[:room_id], params[:reserve_date])
      render json: { status: :ok, payload: { date: params[:reserve_date], agendas: @agendas } }
    end

    def show_agenda
      if params[:token].present?
        @agendas = Agenda.find_reserves(params[:token])
        @agendas = @agendas.map do |agenda|
          {
            office_name: agenda.office_name,
            room_name: agenda.room_name,
            reserve_name: agenda.reserve_name,
            reserve_date: agenda.reserve_date.strftime("%d/%m/%Y"),
            reserved_time: "#{agenda.start_time}:00 às #{agenda.start_time + 1}:00"
          }
        end
        render json: { status: :ok, payload: @agendas }
      else
        render json: { status: 'invalid', error: 'Verifique se todos os campos obrigatórios foram preenchidos.' }
      end
    end

    def new; end

    def update_agenda
      @agenda = Agenda.where(token: params[:token]).order(:start_time).first
      if @agenda.update(agenda_params)
        render json: { status: :ok, payload: @agenda }
      else
        render json: { status: 'invalid', error: @agenda.errors }
      end
    end

    def create
      @agenda = Agenda.new(agenda_params)
      @agenda.office_id = @room.office_id
      if @agenda.save
        render json: { status: :ok, payload: @agenda }
      else
        render json: { status: 'invalid', error: @agenda.errors }
      end
    end

    def delete_agenda
      @agenda = Agenda.where(token: params[:token])
      if @agenda.destroy_all
        render json: { status: :ok, payload: "Agendamento cancelado." }
      else
        render json: { status: 'invalid', payload: "Ops, Algo deu errado.. Tente novamente!" }
      end
    end

    private

    def load_room
      @room = Room.find_by(id: params[:room_id])
      render json: { status: 'fail', error: 'Sala não encontrada!' } unless @room.present?
    end

    def agenda_params
      params.fetch(:agenda).permit(:room_id,
                                   :token,
                                   :start_time,
                                   :amount_of_hours,
                                   :reserve_date,
                                   :reserve_name)
    end
  end
end
