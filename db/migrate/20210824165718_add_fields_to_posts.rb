class AddFieldsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :family, :boolean
    add_column :posts, :family_name, :string
  end
end
