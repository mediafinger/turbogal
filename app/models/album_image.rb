class AlbumImage < ActiveRecord::Base
  belongs_to :album
  belongs_to :image
end
