class CreateSizes < ActiveRecord::Migration[5.2]
  def change
    create_table :sizes do |t|
      t.integer :size_n, default: 1

      t.timestamps null: false
    end
  end
end
