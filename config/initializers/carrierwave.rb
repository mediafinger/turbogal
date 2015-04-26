module CarrierWave

  module MiniMagick
    # check for images that are larger than you probably want
    def validate_dimensions
      manipulate! do |img|
        if img.dimensions.any? { |i| i > 4096 }
          raise CarrierWave::ProcessingError, "dimensions too large"
        end
        img
      end
    end

    def quality(percentage)
      percentage = [[0, percentage].max, 100].min # ensure a value between 0 and 100 is used

      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    # this method shrinks larger pictures
    # without changing their ascpect ratio
    # and returns the largest allowed picture
    # in the desired quality
    # and the given format
    def shrink_to_fit(width, height, quality, format)
      manipulate! do |image|
        img_width, img_height = image.dimensions

        image.format(format) do |img|
          if img_width > width || img_height > height
            ratio_width  = img_width / width.to_f
            ratio_height = img_height / height.to_f

            if ratio_width >= ratio_height
              img.resize "#{width}x#{(img_height / ratio_width).round}"
            else
              img.resize "#{(img_width / ratio_height).round}x#{height}"
            end
          end

          img.quality(quality.to_s)
          image = yield(img) if block_given?
        end

        image
      end
    end

    # TODO: read more about ImageMagick's geometry to write better methods:
    # http://www.imagemagick.org/www/command-line-processing.html#geometry

    # this method resizes pictures
    # without changing their ascpect ratio
    # it trims borders
    # and it crops the images to yield the given dimensions
    # in the desired quality
    # and the given format
    def process_to_fill(width, height, quality, format)
      manipulate! do |image|
        image.fuzz "3%" # fuzzy treatment of "the same color" for the trim command
        image.trim      # automatically removes borders from images (areas of the same color)
        img_width, img_height = image[:dimensions]

        image.format(format) do |img|
          image = yield(img) if block_given?
        end

        image.combine_options do |combo|
          if width != img_width || height != img_height
            ratio_width = width / img_width.to_f
            ratio_height = height / img_height.to_f

            if ratio_width >= ratio_height
              img_width = (ratio_width * (img_width + 0.5)).round
              img_height = (ratio_width * (img_height + 0.5)).round
              combo.resize "#{img_width}"
            else
              img_width = (ratio_height * (img_width + 0.5)).round
              img_height = (ratio_height * (img_height + 0.5)).round
              combo.resize "x#{img_height}"
            end
          end

          combo.gravity "Center"
          combo.background "rgba(255,255,255,0.0)"
          combo.extent "#{width}x#{height}" if img_width != width || img_height != height
          # combo.crop "#{width}x#{height}-0-0" if img_width != width || img_height != height
        end

        image.quality(quality.to_s)
        image = yield(image) if block_given?

        image
      end
    end
  end
end

CarrierWave.configure do |config|
  if Rails.env.development?
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false

  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false

  elsif Rails.env.production?
    config.dropbox_access_token         = ENV["DROPBOX_ACCESS_TOKEN"]
    config.dropbox_access_token_secret  = ENV["DROPBOX_ACCESS_TOKEN_SECRET"]
    config.dropbox_access_type          = "dropbox"
    config.dropbox_app_key              = ENV["DROPBOX_APP_KEY"]
    config.dropbox_app_secret           = ENV["DROPBOX_APP_SECRET"]
    config.dropbox_user_id              = ENV["DROPBOX_USER_ID"]
  end
end
