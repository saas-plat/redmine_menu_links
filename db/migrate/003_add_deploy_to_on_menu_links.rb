class AddDeployToOnMenuLinks < ActiveRecord::Migration
  def self.up
    add_column(:menu_links, "deploy_to", :integer, :default => 0)
  end

  def self.down
    remove_column(:menu_links, "deploy_to")
  end
end
