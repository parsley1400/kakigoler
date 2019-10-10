class CreateIces < ActiveRecord::Migration[5.2]
  def change
    create_table :ices do |t|
      t.integer :ice_n, default: 1

      t.timestamps null: false
    end
  end
end
