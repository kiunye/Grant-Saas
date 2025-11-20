class CreateUsageLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :usage_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.string :created_month

      t.timestamps
    end
  end
end
