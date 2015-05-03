class AlbumImage < ActiveRecord::Base
  belongs_to :album
  belongs_to :image

  attr_accessor :swapping_images # needed for conditional validation of uniqueness

  validates :position, :numericality => { only_integer: true, greater_than: 0 }
  validates_uniqueness_of :position, scope: :album, unless: :swapping_images

  before_validation :ensure_position, on: :create

  class ImageNotPartOfAlbumError < StandardError; end

  def ensure_position
    return if position.present?

    self.position = 1 + album.last_image_position
  end

  def swap_positions(album_image)
    raise ImageNotPartOfAlbumError unless album_image.album == album

    AlbumImage.transaction do
      self.swapping_images = true
      self.position, album_image.position = album_image.position, position

      save!
      album_image.save!

      self.swapping_images = false
    end
  end
end
