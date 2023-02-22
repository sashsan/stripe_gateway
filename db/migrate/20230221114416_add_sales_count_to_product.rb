class AddSalesCountToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sales_count, :integer
  end
end
