# puma server configuration: https://github.com/puma/puma

threads 8,32
workers 2
worker_timeout 20
preload_app!
tag 'turbogal'  # text to display in process listing
