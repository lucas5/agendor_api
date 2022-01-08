require 'swagger_helper'

describe 'Agendas API' do

  path '/api/agendas/available_times/{room_id}/{date}' do
    get 'Visualizar hórarios disponíveis' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :room_id, in: :path, type: :integer
      parameter name: :date, in: :path, type: :string

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/agendas/show_agenda/{token}' do
    get 'Visualizar uma agenda específica' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :token, in: :path, type: :string

      response '200', 'Requisição aceita' do
      end

      response '400', 'Requisição inválida' do
      end
    end
  end

  path '/api/agendas/agenda_list/{room_id}/{reserve_date}' do
    get 'Visualizar horários agendados' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :room_id, in: :path, type: :integer
      parameter name: :reserve_date, in: :path, type: :string

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/agendas/' do
    post 'Reservar horário' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :agenda, in: :body, schema: {
        type: :object,
        properties: {
          room_id: { type: :integer },
          start_time: { type: :integer },
          amount_of_hours: { type: :integer },
          reserve_date: { type: :string },
          reserve_name: { type: :string }
        },
        required: ['room_id', 'start_time', 'reserve_date', 'reserve_name']
      }

      response '200', 'Reserva criada' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/agendas/update_agenda' do
    put 'Atualizar informações do agendamento' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :agenda, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :integer },
          room_id: { type: :integer },
          start_time: { type: :string },
          reserve_name: { type: :string }
        },
        required: ['token', 'room_id', 'start_time', 'reserve_name']
      }

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/agendas/delete_agenda' do
    delete 'Cancelar agendamento' do
      tags 'Agendas'
      consumes 'application/json'
      parameter name: :agenda, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :integer }
        },
        required: ['token']
      }

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/offices/{id}/rooms' do
    get 'Visualizar todas as salas de um escritório' do
      tags 'Offices'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end

  path '/api/offices/' do
    get 'Listar todos os escritórios' do
      tags 'Offices'
      consumes 'application/json'

      response '200', 'Requisição aceita' do
      end

      response '404', 'Requisição inválida' do
      end
    end
  end
end
