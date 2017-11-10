require 'redmine'
require 'redmine_menu_links_hooks'

Rails.logger.info 'Starting Menu Links Plugin for Redmine'

Redmine::Plugin.register :redmine_menu_links do
  name 'Menu Links Plugin'
  author 'Tide, Yuki Kita, José Cavalcanti, SamSK'
  description 'A plugin which adds links to the top menu of Redmine.'
  url         'git://git@saas-plat.com:saas-plat-redmine/redmine_menu_links' if respond_to?(:url)
  version '1.0.2'

  menu :admin_menu, :redmine_menu_links, { :controller => 'menu_links', :action => 'index'}, :caption => :label_menu_links
end

MenuLink.show if MenuLink.table_exists?
