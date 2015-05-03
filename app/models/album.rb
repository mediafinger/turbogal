require 'upsert/active_record_upsert'

class Album < ActiveRecord::Base
  belongs_to :user
  has_many   :album_images
  has_many   :images, through: :album_images

  def last_image_position
    album_images.pluck(:position).max.to_i
  end

  def compact
    return unless positions_have_gaps

    compact! album_images.order(:position).pluck(:id)
  end

  private

  def positions_have_gaps
    last_image_position > album_images.count
  end

  # expensive operation made cheaper with upsert
  def compact!(ids)
    Upsert.batch(AlbumImage.connection, :album_images) do |upsert|
      ids.each_with_index do |id, index|
        upsert.row({ id: id }, position: index + 1)
      end
    end
  end
end
