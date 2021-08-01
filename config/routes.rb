Rails.application.routes.draw do

  devise_for :users

  root "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search"
  get "chat/:id" => "chats#show", as: "chat"

  resources :users do
    get "search" => "users#search"
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :chats, only: [:create]
  resources :groups
end
