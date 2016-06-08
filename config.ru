require 'sinatra'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/numeric/time'

require 'json'
require 'open-uri'
require 'yaml'

YAML.load(File.read('./config/config.yml'))[ENV['RACK_ENV'] || 'development'].each do |key, value|
  ENV.store(key, value)
end
ENV['api_key'] ||=
  YAML.load(File.read('./config/secrets.yml'))[ENV['RACK_ENV'] || 'development']['api_key']
ENV['request_base'] =
  "#{ENV['api_base']}?key=#{ENV['api_key']}&part=contentDetails&maxResults=50"

# TODO warum failt das manchmal auf heroku only? reihenfolge!
#      warum geht dann autoload auch nicht (siehe tamyca_core)
Dir.glob('./app/controllers/*.rb').each { |file| require file }

map('/') { run RedirectController }
