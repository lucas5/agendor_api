Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :offices
    resources :rooms
    resources :agendas, :except => [:show, :destroy, :update]

    get '/offices/:id/rooms', to: 'offices#rooms'

    # Agenda endpoints
    get '/agendas/available_times/:room_id/:date', to: 'agendas#available_times'
    get '/agendas/show_agenda/:token', to: 'agendas#show_agenda'
    get '/agendas/agenda_list/:room_id/:reserve_date', to: 'agendas#agenda_list'
    delete '/agendas/delete_agenda', to: 'agendas#delete_agenda'
    put '/agendas/update_agenda', to: 'agendas#update_agenda'
  end
end
