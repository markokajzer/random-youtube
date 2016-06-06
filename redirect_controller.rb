class RedirectController < ApplicationController

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

end
