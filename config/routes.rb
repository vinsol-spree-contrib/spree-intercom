Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resource :intercom_setting, only: [:edit, :update]
  end
end
