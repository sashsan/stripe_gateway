class AddIndexIdToProduct < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :id
  end
end
