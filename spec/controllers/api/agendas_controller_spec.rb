require 'rails_helper'

RSpec.describe Api::AgendasController, type: :controller do

  context 'View reservations' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
      @agenda = FactoryBot.create(:agenda, room_id: @room.id, office_id: @room.office_id, reserve_date: '02/01/2023')
    end

    describe 'GET #show_agenda' do
      it 'returns a 200' do
        get :show_agenda, params: { token: @agenda.token }
        result = JSON.parse(response.body)
        expect(result['payload'][0]['reserve_date']).to eq('02/01/2023')
      end

      it 'returns a 422 (Invalid token)' do
        get :show_agenda, params: { token: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'View available reservations' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
      @agenda = FactoryBot.create(:agenda, room_id: @room.id, office_id: @room.office_id, reserve_date: '02/01/2023')
    end

    describe 'GET #available_times' do
      it 'returns a 200' do
        get :available_times, params: { room_id: @room.id, date: '02/01/2023' }
        result = JSON.parse(response.body)
        expect(result['payload'].size).to eq(8)
      end

      it 'returns a 404 (Room not found)' do
        get :available_times, params: { room_id: 0, date: '02/01/2023' }
        expect(response).to have_http_status(404)
      end
    end
  end

  context 'View reserved times' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
      @agenda = FactoryBot.create(:agenda, room_id: @room.id, office_id: @room.office_id, reserve_date: '02/01/2023')
    end

    describe 'GET #agenda_list' do
      it 'returns a 200' do
        get :agenda_list, params: { room_id: @room.id, reserve_date: '02/01/2023' }
        result = JSON.parse(response.body)
        expect(result['payload']['agendas'].size).to eq(1)
      end

      it 'returns a 404 (Room not found)' do
        get :agenda_list, params: { room_id: 0, reserve_date: '02/01/2023' }
        expect(response).to have_http_status(404)
      end
    end
  end

  context 'Schedule an reserve' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
    end

    describe 'POST #create' do
      it 'returns a 200' do
        post :create, params: { room_id: @room.id,
                                start_time: 9,
                                amount_of_hours: 1,
                                reserve_date: '02/01/2023',
                                reserve_name: 'User 1' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 404 (Room not found)' do
        post :create, params: { room_id: 0,
                                start_time: 9,
                                amount_of_hours: 1,
                                reserve_date: '02/01/2023',
                                reserve_name: 'User 1' }
        expect(response).to have_http_status(404)
      end

      it 'returns a 422 (Invalid params)' do
        post :create, params: { room_id: @room.id,
                                start_time: 8,
                                amount_of_hours: 1,
                                reserve_date: '02/01/2023',
                                reserve_name: 'User 1' }
        expect(response).to have_http_status(422)
      end
    end
  end

  context 'Cancel an reserve' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
      @agenda = FactoryBot.create(:agenda, room_id: @room.id, office_id: @room.office_id, reserve_date: '02/01/2023')
    end

    describe 'DELETE #delete_agenda' do
      it 'returns a 200' do
        post :delete_agenda, params: { token: @agenda.token }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 422' do
        post :delete_agenda, params: { token: '' }
        expect(response).to have_http_status(422)
      end
    end
  end

  context 'Update an reserve' do
    before do
      @office = FactoryBot.create(:office, name: 'GetNinjas', capacity: 4)
      @room = FactoryBot.create(:room, office_id: @office.id, name: 'Sala 1')
      @agenda = FactoryBot.create(:agenda, room_id: @room.id, office_id: @room.office_id, reserve_date: '02/01/2023')
    end

    describe 'PUT #update_agenda' do
      it 'returns a 200' do
        put :update_agenda, params: { token: @agenda.token,
                                      room_id: @room.id,
                                      start_time: 10,
                                      amount_of_hours: 2,
                                      reserve_date: '03/01/2023',
                                      reserve_name: 'User 2' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 422' do
        post :update_agenda, params: { token: '',
                                       room_id: @room.id,
                                       start_time: 11,
                                       amount_of_hours: 3,
                                       reserve_date: '04/01/2023',
                                       reserve_name: 'User 3' }
        expect(response).to have_http_status(422)
      end
    end
  end
end
