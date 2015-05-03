require "rails_helper"

describe Album do
  describe "last_image_position" do
    it "returns 0 when the album is empty" do
      result = Album.new.last_image_position

      expect(result).to eq 0
    end

    it "returns number of images when they are positioned without gaps" do
      album = Album.new
      image = Image.new
      AlbumImage.create(album: album, image: image)
      AlbumImage.create(album: album, image: image)

      expect(album.last_image_position).to eq 2
    end

    it "returns the highest position of the images" do
      album = Album.new
      image = Image.new
      AlbumImage.create(album: album, image: image, position: 3)
      AlbumImage.create(album: album, image: image, position: 5)

      expect(album.last_image_position).to eq 5
    end
  end

  describe "compact" do
    self.use_transactional_fixtures = false # to use the UPSERT functionality

    let(:album)         { Album.new }
    let(:image)         { Image.new }
    let(:album_image_a) { AlbumImage.new(album: album, image: image) }
    let(:album_image_b) { AlbumImage.new(album: album, image: image) }

    context "when the album is empty" do
      it "does nothing" do
        expect(album.compact).to eq nil
      end
    end

    context "when the album has no gaps" do
      before do
        album_image_a.save
        album_image_b.save
      end

      it "does nothing" do
        expect(album.compact).to eq nil
      end
    end

    context "when the album has gaps" do
      before do
        album_image_a.position = 5
        album_image_a.save

        album_image_b.position = 10
        album_image_b.save
      end

      it "keeps the sorting" do
        expect(album.compact).to eq [album_image_a.id, album_image_b.id]
      end

      it "removes the gaps" do
        album.compact

        expect(album_image_a.reload.position).to eq 1
        expect(album_image_b.reload.position).to eq 2
      end
    end
  end
end
