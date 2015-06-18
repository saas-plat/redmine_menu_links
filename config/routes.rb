RedmineApp::Application.routes.draw do
  get 'menu_links/index', :controller => 'menu_links', :action => 'index'
  get 'menu_links/new', :controller => 'menu_links', :action => 'new'
  post 'menu_links/create', :controller => 'menu_links', :action => 'create'
  get 'menu_links/edit', :controller => 'menu_links', :action => 'edit'
  patch 'menu_links/update', :controller => 'menu_links', :action => 'update'
  post 'menu_links/destroy', :controller => 'menu_links', :action => 'destroy'
end