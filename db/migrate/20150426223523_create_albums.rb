class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.references :user, index: true

      t.string :name
      t.text   :description

      t.timestamps
    end

    create_table :album_images do |t|
      t.references :album, index: true
      t.references :image, index: true

      t.integer :position

      t.timestamps
    end

    add_index :album_images, [:album_id, :position]
  end
end
