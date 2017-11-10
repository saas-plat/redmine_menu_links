class MenuLink < ActiveRecord::Base
  acts_as_list
  attr_accessible :name, :url, :link_type, :is_enabled, :new_window, :relative_url, :deploy_to

  validates_presence_of :name, :url
  validates_length_of :name, :maximum => 60
  validates_length_of :url, :maximum => 255
  validates_format_of :url, :with => URI.regexp(['http', 'https']), :if => "!relative_url"

  EVERYONE = 0
  USERS_ONLY = 1
  ADMINISTRATORS_ONLY = 2

  ACCOUNTMENU = 1
  TOPMENU = 0

  def to_s
    name
  end

  def <=>(link)
    position <=> link.position
  end

  def to_sym
    "menu_link_#{self.id}".to_sym
  end

  def for_everyone?
    link_type == EVERYONE
  end

  def for_users_only?
    link_type == USERS_ONLY
  end

  def for_administrators_only?
    link_type == ADMINISTRATORS_ONLY
  end

  def deploy_to_account_menu?
    deploy_to == ACCOUNTMENU
  end

  def deploy_to_top_menu?
    deploy_to == TOPMENU
  end

  def self.each_enabled_link
    self.all.select(&:is_enabled).sort_by(&:position).each do |menu_link|
      yield menu_link
    end
  end

  def self.clean
    self.each_enabled_link do |menu_link|
      if menu_link.deploy_to_account_menu?
        Redmine::MenuManager.map(:account_menu).delete(menu_link.to_sym)
      else
        Redmine::MenuManager.map(:top_menu).delete(menu_link.to_sym)
      end
    end
  end

  def self.show
    Redmine::MenuManager.map(:top_menu).delete(:help);
    Redmine::MenuManager.map(:top_menu).delete(:my_page);
    Redmine::MenuManager.map(:top_menu).delete(:home);
    Redmine::MenuManager.map(:top_menu).delete(:projects);

    Redmine::MenuManager.map(:account_menu).delete(:login);
    Redmine::MenuManager.map(:account_menu).delete(:register);
    Redmine::MenuManager.map(:account_menu).delete(:my_account);
    Redmine::MenuManager.map(:account_menu).delete(:logout);

    # issues
    Redmine::MenuManager.map(:application_menu).delete(:issues);
    Redmine::MenuManager.map(:application_menu).push :issues, {:controller => 'issues', :action => 'index'},
      :if => Proc.new {User.current.allowed_to?(:view_issues, nil, :global => true)},
      :caption => :label_issue_plural,
      :before => :projects

    self.each_enabled_link do |menu_link|
      option = {:caption=>menu_link.name, :before => :administration}
      option[:html] = {:target => '_blank'} if menu_link.new_window
      option[:if] = menu_link.for_users_only? ? Proc.new {User.current.logged?} : (menu_link.for_administrators_only? ? Proc.new {User.current.admin?} : nil)
      if menu_link.deploy_to_account_menu?
        Redmine::MenuManager.map(:account_menu).push(menu_link.to_sym, menu_link.url, option)
      else
        Redmine::MenuManager.map(:top_menu).push(menu_link.to_sym, menu_link.url, option)
      end
    end

    # logout
    Redmine::MenuManager.map(:account_menu).push :logout, :signout_path, :html => {:method => 'post'}, :if => Proc.new { User.current.logged? }
  end
end
