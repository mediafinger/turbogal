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
