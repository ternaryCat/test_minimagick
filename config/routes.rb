Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post :process_image, to: 'mini_magick#process_image', as: :process_image
    end
  end
end
