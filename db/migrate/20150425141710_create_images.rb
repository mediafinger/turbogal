class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :user, index: true

      t.string   :image
      t.string   :format
      t.integer  :height
      t.integer  :width
      t.integer  :size
      t.string   :filename
      t.string   :name
      t.string   :location
      t.text     :description
      t.date     :date
      t.datetime :taken_at

      t.timestamps
    end
  end
end
