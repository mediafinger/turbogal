class Image < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader

  before_save :write_file_size

  # TODO: add size Validator

  # to format filenames like this: originalname_suffix.extension
  # and not have the version_ at the beginning of a filename
  # the "name" passed by the ImageUploader looks like: "thumb_original.png"
  # and gets returned i.e. as "original_mythumb.jpg"
  def formatted_filename(name, version, suffix, extension)
    name.gsub("#{version}_", "").chomp(File.extname(name)) + "_#{suffix}.#{extension}"
  end

  # def self.upload(file)
  #   uploader = ImageUploader.new
  #   uploader.store!(file)
  # end

  # def self.download(name)
  #   url = name
  #   uploader.retrieve_from_store!(url)
  # end

  private

  def write_file_size
    self.size = image.size
  end
end
