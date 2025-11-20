class CreateSubscriptionPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.integer :generations_per_month
      t.integer :price_cents
      t.boolean :allows_export
      t.string :stripe_price_id

      t.timestamps
    end
  end
end
