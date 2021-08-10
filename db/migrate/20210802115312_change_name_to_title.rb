class ChangeNameToTitle < ActiveRecord::Migration[6.0]
  def change
    rename_column :tags, :name, :title
  end
end
