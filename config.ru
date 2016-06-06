require 'sinatra'

require 'active_support/core_ext/time'
require 'json'
require 'open-uri'

Dir.glob('./controllers/*.rb').each { |file| require file }

map('/') { run RedirectController }
