class AddStripeIdToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :stripe_id, :text
    add_index :products, :stripe_id
  end
end
