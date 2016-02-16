class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.belongs_to :user, { index: true }

      t.string :title, { limit: 64, null: false }
      t.text :body, { null: false }

      t.timestamps(null: false)
    end
  end
end
