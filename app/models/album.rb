class Album < ActiveRecord::Base
  belongs_to :user
  has_many   :album_images
  has_many   :images, through: :album_images
end
