class CreateSweets < ActiveRecord::Migration[5.2]
  def change
    create_table :sweets do |t|
      t.integer :sweet_n, default: 1

      t.timestamps null: false
    end
  end
end
