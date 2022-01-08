module Api
  class AgendasController < ApiController
    before_action :load_room, only: %i[available_times create agenda_list]

    # GET /agendas/available_times/:room_id/:date
    def available_times
      available_times = Agenda.available_times(params[:date], @room)
      render json: { payload: available_times }, status: :ok
    end

    # GET /agendas/agenda_list/:room_id/:reserve_date
    def agenda_list
      @agendas = Agenda.agenda_list(params[:room_id], params[:reserve_date])
      render json: { payload: { date: params[:reserve_date], agendas: @agendas } }, status: :ok
    end

    # GET /agendas/show_agenda/:token
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
        render json: { payload: @agendas }, status: :ok
      else
        render json: { error: 'Verifique se todos os campos obrigatórios foram preenchidos.' }, status: :unprocessable_entity
      end
    end

    # PUT /agendas/update_agenda
    def update_agenda
      @agenda = Agenda.where(token: params[:token]).order(:start_time).first
      if @agenda.present? && @agenda.update(agenda_params)
        render json: { payload: @agenda }, status: :ok
      else
        errors = @agenda.present? ? @agenda&.errors : "Token inválido"
        render json: { error: errors }, status: :unprocessable_entity
      end
    end

    # POST /agendas
    def create
      @agenda = Agenda.new(agenda_params)
      @agenda.office_id = @room.office_id
      if @agenda.save
        render json: { payload: @agenda }, status: :ok
      else
        render json: { error: @agenda.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /agendas/delete_agenda
    def delete_agenda
      @agenda = Agenda.where(token: params[:token])
      if @agenda.present? && @agenda.destroy_all
        render json: { payload: "Agendamento cancelado." }, status: :ok
      else
        render json: { error: "Ops, Algo deu errado.. Tente novamente!" }, status: :unprocessable_entity
      end
    end

    private

    def load_room
      @room = Room.find_by(id: params[:room_id])
      render json: { error: 'Sala não encontrada!' }, status: :not_found unless @room.present?
    end

    def agenda_params
      params.permit(:room_id,
                    :token,
                    :start_time,
                    :amount_of_hours,
                    :reserve_date,
                    :reserve_name)
    end
  end
end
