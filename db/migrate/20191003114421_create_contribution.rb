class CreateContribution < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.string :image
      t.references :sweet
      t.references :ice
      t.references :size
      t.references :plo
      t.references :price
      t.string :store
      t.string :icename
      t.string :station
      t.references :user
      t.boolean :favorite, default: false

      t.timestamps null: false
    end
  end
end
