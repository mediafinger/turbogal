# Make the load path include directories recursively
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**/', '*.{rb,yml}')]

I18n.enforce_available_locales  = true
I18n.available_locales          = [:de, :en]
I18n.default_locale             = :en
