class RedirectController < ApplicationController
  cache = {}

  get '/' do
    playlist = params['playlist'] || ENV['playlist_id']

    videos = if cache[playlist].present? && cache[playlist]['cache_until'] > Time.now
      cache[playlist]['videos']
    else
      save_video_ids(playlist, cache)
    end

    redirect to("#{ENV['youtube_base']}#{videos.sample}&list=#{playlist}")
  end

  helpers do
    def save_video_ids(playlist, cache)
      videos = []
      count = 0
      max_results = nil
      next_page = ''

      while max_results.nil? || count < max_results
        request_url = "#{ENV['request_base']}&playlistId=#{playlist}&pageToken=#{next_page}"
        begin
          response = JSON.parse(open(request_url).read)
        rescue OpenURI::HTTPError => e
          handle_errors(e)
        end

        response['items'].each do |video|
          videos << video['contentDetails']['videoId']
        end

        count += response['pageInfo']['resultsPerPage']
        max_results = response['pageInfo']['totalResults'] if max_results.nil?
        next_page = response['nextPageToken']
      end

      cache[playlist] = {}
      cache[playlist]['cache_until'] = 24.hours.from_now
      cache[playlist]['videos'] = videos
    end
  end

  def handle_errors(error)
    halt({ code: error.io.status[0], message: error.io.status[1] }.to_json)
  end
end
