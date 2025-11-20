class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.json :form_data
      t.string :status

      t.timestamps
    end
  end
end
