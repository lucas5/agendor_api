module Api
  class RoomsController < ApiController
    before_action :set_room, only: [:show]

    # GET /rooms/:id
    def show
      render json: { status: :ok, payload: @room }
    end

    private

    def set_room
      @room = Room.find_by(id: params[:id])
    end
  end
end
