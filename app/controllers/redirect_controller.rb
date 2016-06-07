class RedirectController < ApplicationController
  cache = {}

  get '/' do
    playlist = params['playlist'] || CONFIG[:playlist_id]

    videos = if cache[playlist].present?
      if cache[playlist]['cache_until'] < Time.now
        save_video_ids(playlist, cache)
      else
        cache[playlist]['videos']
      end
    else
      save_video_ids(playlist, cache)
    end

    redirect to("#{CONFIG[:youtube_base]}#{videos.sample}&list=#{playlist}")
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
        request_url = "#{CONFIG[:request_base]}&playlistId=#{playlist}&pageToken=#{next_page}"
        response = JSON.parse(open(request_url).read)
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
