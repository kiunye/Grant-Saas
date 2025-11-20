class CreatePaymentTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :currency
      t.string :paystack_reference
      t.string :status
      t.datetime :transaction_date

      t.timestamps
    end
  end
end
