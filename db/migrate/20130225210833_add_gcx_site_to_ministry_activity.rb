class AddGcxSiteToMinistryActivity < ActiveRecord::Migration
  def change
    add_column :ministry_activity, :gcx_site, :string
  end
end
