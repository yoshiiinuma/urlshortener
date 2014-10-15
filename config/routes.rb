Rails.application.routes.draw do

  resources :urls, only: [:index, :show, :new, :create, :destroy]

  root 'urls#new'

  get ':shortened_url', to: 'short_url#redirect', format: false,
    constraints: { shortened_url: /[A-Za-z0-9]{6}/ }, as: 'short'

end
