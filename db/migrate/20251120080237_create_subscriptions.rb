class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription_plan, null: false, foreign_key: true
      t.string :paystack_customer_code
      t.string :paystack_subscription_code
      t.string :status
      t.date :next_payment_date

      t.timestamps
    end
  end
end
