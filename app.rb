class ApplicationController < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  API_KEY = 'AIzaSyBBsV-c_xH9aWo8qANU3b6mfVrRilesPNs'
  PLAYLIST_ID = 'PL_H04AvN5HJNrZSL_0M6lIjmLAvjOXs7u'
  BASE_URL = 'https://www.googleapis.com/youtube/v3/playlistItems'
  REQUEST_BASE = "#{BASE_URL}?key=#{API_KEY}&playlistId=#{PLAYLIST_ID}" +
                            "&part=contentDetails&maxResults=50"
  YOUTUBE_BASE = 'https://www.youtube.com/watch?v='

end
