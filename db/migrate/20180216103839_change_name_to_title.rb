class ChangeNameToTitle < ActiveRecord::Migration[5.1]
  def change
    rename_column :bucketlists, :name, :title
  end
end
