class RedirectController < ApplicationController

  cache = {}

  get '/' do
    playlist = params['playlist'] || PLAYLIST_ID

    videos = if cache[playlist].present?
      if cache[playlist]['cache_until'] < Time.now
        save_video_ids(playlist, cache)
      else
        cache[playlist]['videos']
      end
    else
      save_video_ids(playlist, cache)
    end

    redirect to("#{YOUTUBE_BASE}#{videos.sample}&list=#{playlist}")
  end

  helpers do
    def save_video_ids(playlist, cache)
      videos = []
      max_results = count = 0
      next_page = ''

      while not count > max_results
        #
        # TODO Fix raising 403 if privat playlist
        #
        response = JSON.parse(open("#{REQUEST_BASE}&playlistId=#{playlist}&pageToken=#{next_page}").read)
        response['items'].each do |video|
          videos << video['contentDetails']['videoId']
        end

        count += response['pageInfo']['resultsPerPage']
        max_results = response['pageInfo']['totalResults'] if max_results.zero?
        next_page = response['nextPageToken']
      end

      cache[playlist] = {}
      cache[playlist]['cache_until'] = Time.now + 24.hours
      cache[playlist]['videos'] = videos
    end
  end

end
