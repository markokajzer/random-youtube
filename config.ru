require 'sinatra'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/numeric/time'

require 'json'
require 'open-uri'
require 'yaml'

# TODO how to handle secrets (api_key) with heroku?
CONFIG =
  YAML.load(File.read('./config/config.yml'))[ENV['RACK_ENV'] || 'development'].symbolize_keys
CONFIG[:api_key] =
  ENV['YOUTUBE_API_KEY'] ||
  YAML.load(File.read('./config/secrets.yml'))[ENV['RACK_ENV'] || 'development']['api_key']
CONFIG[:request_base] =
  "#{CONFIG[:api_base]}?key=#{CONFIG[:api_key]}&part=contentDetails&maxResults=50"

Dir.glob('./app/controllers/*.rb').each { |file| require file }

map('/') { run RedirectController }
