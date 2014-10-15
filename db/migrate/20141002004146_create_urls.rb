class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original
      t.string :shortened

      t.timestamps
    end

    add_index :urls, :shortened
  end
end
