require 'bundler'
Bundler.require(:default)

require 'open-uri'

Dir.glob('./*.rb').each { |file| require file }

map('/') { run RedirectController }
