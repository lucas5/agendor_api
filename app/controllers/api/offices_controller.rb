module Api
  class OfficesController < ApiController
    before_action :set_office, only: [:show]

    # GET /offices
    def index
      @offices = Office.all
      render json: { status: :ok, payload: @offices }
    end

    # GET /offices/:id
    def show
      render json: { status: :ok, payload: @office }
    end

    # GET /offices/:id/rooms
    def rooms
      rooms = Room.where(office_id: params[:id])
      render json: { status: :ok, payload: rooms }
    end

    private

    def set_office
      @office = Office.find_by(id: params[:id])
    end
  end
end
