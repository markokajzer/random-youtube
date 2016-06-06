require 'sinatra/base'
require 'open-uri'
require 'json'

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

  get '/' do
    video_ids = []
    max_results = count = 0
    next_page = ''

    while not count > max_results
      response = JSON.parse(open("#{REQUEST_BASE}&pageToken=#{next_page}").read)
      response['items'].each do |video|
        video_ids << video['contentDetails']['videoId']
      end

      count += response['pageInfo']['resultsPerPage']
      max_results = response['pageInfo']['totalResults'] if max_results.zero?
      next_page = response['nextPageToken']
    end

    redirect to("#{YOUTUBE_BASE}#{video_ids.sample}&list=#{PLAYLIST_ID}")
  end

  run!

end
