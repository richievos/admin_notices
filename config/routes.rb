ActionController::Routing::Routes.draw do |map|
  map.namespace 'admin' do |admin|
    admin.resources :notices, :only => 'index'
  end
end
