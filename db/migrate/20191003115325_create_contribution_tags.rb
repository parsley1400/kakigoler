class CreateContributionTags < ActiveRecord::Migration[5.2]
  def change
    create_table :contribution_tags do |t|
      t.references :tag
      t.references :contribution

      t.timestamps null: false
    end
  end
end
