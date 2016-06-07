require 'sinatra'

require 'active_support/time'
require 'json'
require 'open-uri'

Dir.glob('./app/controllers/*.rb').each { |file| require file }

map('/') { run RedirectController }
