class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.string :name
      t.string :notes

      t.timestamps
    end
  end
end
