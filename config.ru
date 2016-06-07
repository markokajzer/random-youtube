require 'sinatra'

require 'active_support/time'
require 'active_support/core_ext/hash/keys'
require 'json'
require 'open-uri'
require 'yaml'

CONFIG = YAML.load(File.read('./config.yml'))[ENV['RACK_ENV'] || 'development'].symbolize_keys
CONFIG[:request_base] = "#{CONFIG[:api_base]}?key=#{CONFIG[:api_key]}&part=contentDetails&maxResults=50"

Dir.glob('./app/controllers/*.rb').each { |file| require file }

map('/') { run RedirectController }
