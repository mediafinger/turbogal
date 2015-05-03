require "rails_helper"

describe AlbumImage do
  let(:album)         { Album.new }
  let(:image)         { Image.new }
  let(:album_image_a) { AlbumImage.new(album: album, image: image) }
  let(:album_image_b) { AlbumImage.new(album: album, image: image) }

  describe "validate_position" do
    it "validates that position is a number" do
      album_image_a.position = "five"
      expect { album_image_a.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "validates that position is an Integer" do
      album_image_a.position = 5.5
      expect { album_image_a.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "validates that position is greater than 0" do
      album_image_a.position = -1
      expect { album_image_a.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "validates that position is not taken yet" do
      album_image_a.position = 1
      album_image_a.save
      album_image_b.position = 1

      expect { album_image_b.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "ensure_position" do
    it "ensures a position" do
      album_image_a.save

      expect(album_image_a.position).to eq 1
    end

    it "ensures a position is set only when none was set before" do
      album_image_a.position = 5
      album_image_a.save

      expect(album_image_a.position).to eq 5
    end

    it "sets the position to the highest + 1" do
      album_image_a.position = 5
      album_image_a.save

      album_image_b.save

      expect(album_image_b.position).to eq 6
    end
  end

  describe "swap_positions" do
    before do
      album_image_a.position = 5
      album_image_a.save

      album_image_b.position = 10
      album_image_b.save
    end

    it "changes the position with the given image" do
      album_image_a.swap_positions(album_image_b)

      expect(album_image_a.position).to eq 10
      expect(album_image_b.position).to eq 5
    end

    it "raises an error when the given image belongs to an other album" do
      album_image_c = AlbumImage.create(album: Album.new, image: image)

      expect { album_image_a.swap_positions(album_image_c) }.to raise_error(AlbumImage::ImageNotPartOfAlbumError)
    end
  end
end
