# This image uploader processes files that match the extension whitelist
# TODO: validate real file type
# when validate_dimensions does not complain
# TODO: validate file_size
# it stores meta data in the model
# it stores the original uploaded file
# and 5 JPEG versions:
# - large, 2048px (longer side) or same dimensions as original, if that is smaller
# - normal, 800px (longer side) or same dimensions as original, if that is smaller
# - card, 400x400
# - thumb, 200x200
# - icon, 64x64
class ImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :fog
  storage :file if Rails.env.development?
  storage :dropbox if Rails.env.production?

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :validate_dimensions

  process :store_meta_data

  version :large  do
    process shrink_to_fit: [2048, 2048, 85, "jpg"]

    def full_filename(for_file = model.image.file)
      model.formatted_filename(super, version_name, "large", "jpg")
    end
  end

  version :normal, from_version: :large do
    process shrink_to_fit: [800, 800, 85, "jpg"]

    def full_filename(for_file = model.image.file)
      # write the original filename without extension to the model
      model.filename = original_filename.chomp(File.extname(original_filename)) unless model.filename

      model.formatted_filename(super, version_name, "normal", "jpg")
    end
  end

  version :card, from_version: :normal do
    process process_to_fill: [400, 400, 85, "jpg"]

    def full_filename(for_file = model.image.file)
      model.formatted_filename(super, version_name, "card", "jpg")
    end
  end

  version :thumb, from_version: :card do
    process process_to_fill: [200, 200, 85, "jpg"]

    def full_filename(for_file = model.image.file)
      model.formatted_filename(super, version_name, "thumb", "jpg")
    end
  end

  version :icon, from_version: :thumb do
    process process_to_fill: [64, 64, 85, "jpg"]

    def full_filename(for_file = model.image.file)
      model.formatted_filename(super, version_name, "icon", "jpg")
    end
  end


  # when changing the format of a file, you need to change the suffix manually:
  # this method calls #full_filename of the corresponding version
  def filename
    super
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  #   # allow files with non-ASCII characters but sanitize them
  #   CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
  # end


  private

  # write data of the original image to the model
  def store_meta_data
    img = ::MiniMagick::Image.open(file.file)

    model.format   = img.type
    model.height   = img.height
    model.width    = img.width

    if img.exif.present?
      exif_date = img.exif["DateTimeOriginal"].split(" ")
      exif_date.first.gsub!(":", "-")

      model.taken_at = DateTime.parse exif_date.join(",")
    end
  end
end
