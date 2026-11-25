Rails.application.routes.draw do
  root 'dashboard#index'

  resources :faculties, only: [:index, :show]
  resources :careers, only: [:index, :show]
  resources :teachers, only: [:index, :show]

  resources :students, only: [:index, :show] do
    member do
      get :transcript
    end
  end

  resources :subjects, only: [:index, :show]

  resources :enrollments, only: [:index, :new, :create] do
    member do
      patch :update_grade
    end
  end

  get 'transcript/:student_code', to: 'transcripts#show', as: :official_transcript
end
