Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :offices
    resources :rooms
    resources :agendas, :except => [:show, :destroy, :update]

    get '/offices/:id/rooms', to: 'offices#rooms'
    get '/agendas/available_times', to: 'agendas#available_times'
    get '/agendas/show_agenda', to: 'agendas#show_agenda'
    delete '/agendas/delete_agenda', to: 'agendas#delete_agenda'
    put '/agendas/update_agenda', to: 'agendas#update_agenda'
    get '/agendas/agenda_list', to: 'agendas#agenda_list'
  end
end
