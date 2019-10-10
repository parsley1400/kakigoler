class CreatePlos < ActiveRecord::Migration[5.2]
  def change
    create_table :plos do |t|
      t.integer :plo_n, default: 1

      t.timestamps null: false
    end
  end
end
