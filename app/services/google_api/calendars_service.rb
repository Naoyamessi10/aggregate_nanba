require 'google/api_client'

module GoogleApi
  class CalendarsService

    def calendar_api_refresh_token(access_token)
      access_token = access_token
      client = Google::APIClient.new(application_name: '')
      client.authorization.client_id = ENV['CLIENT_ID']
      client.authorization.client_secret = ENV['CLIENT_SECRET']
      client.authorization.scope = ENV['SCOPE']
      client.authorization.access_token = access_token
      calendar = client.discovered_api('calendar', 'v3')
      time_min = Time.utc(2019, 1, 1, 00, 00, 00).iso8601
      time_max = Time.utc(2019, 12, 31, 23, 59, 59).iso8601
      params = { 'calendarId' => 'primary',
        'orderBy' => 'startTime',
        'timeMax' => time_max,
        'timeMin' => time_min,
        'singleEvents' => 'True' }
      #google_apiを叩く
      calendar_result = client.execute(api_method: calendar.events.list, parameters: params)
      calendar_result.data.items
    end

    def create_token(params)
      url = 'https://accounts.google.com/o/oauth2/token'
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      oauth_request = Net::HTTP::Post.new(uri.request_uri)
      oauth_request["Content-Type"] = "application/json"
      oauth_request_params = {code: params[:code], grant_type: 'authorization_code',
        redirect_uri: 'http://aggregate.nanba.jp:4202', client_secret: ENV['CLIENT_SECRET'], client_id: ENV['CLIENT_ID']}
      oauth_request.body = oauth_request_params.to_json
      oauth_response = https.request(oauth_request)
      response = JSON.parse(oauth_response.body)
    end

    def refresh_token(user_id)
      url = 'https://accounts.google.com/o/oauth2/token'
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      oauth_request = Net::HTTP::Post.new(uri.request_uri)
      oauth_request["Content-Type"] = "application/json"
      oauth_request_params = {grant_type: 'refresh_token',　redirect_uri: 'http://aggregate.nanba.jp:4202',
        refresh_token: JSON.parse(redis_instance.get(user_id))['refresh_token'], client_secret: ENV['CLIENT_SECRET'], client_id: ENV['CLIENT_ID']}
      oauth_request.body = oauth_request_params.to_json
      oauth_response = https.request(oauth_request)
      response = JSON.parse(oauth_response.body)
      response['access_token']
    end

    def redis_instance
      @redis ||= Redis::Namespace.new('calendars', redis: Redis.new(url: ENV['REDIS_SERVERNAME']))
    end

    def create_new_id(params)
      new_id = generate_uuid
      response = create_token(params)
      save_data = {
        refresh_token: response['refresh_token']
      }
      redis_instance.set(new_id, save_data.to_json)
      redis_instance.expire(new_id, 8 * 60 * 60)
      new_id
    end

    def exists(key)
      redis_instance.exists(key)
    end

    def generate_uuid
      uuid = nil
      loop do
        uuid = SecureRandom.uuid
        break unless redis_instance.exists(uuid)
      end
      uuid
    end
    
  end
end
