module Api::V1::Concerns::GenericApiConcern

  # generic implementation of simple linstener in active record
  def call_generic_api(url, subUrl, basic_auth, body, params, request_type)

    conn = Faraday.new(url) do |c|
      c.adapter Faraday::Adapter::NetHttp
    end

    if basic_auth
      conn.basic_auth basic_auth[:username], basic_auth[:password]
    end

    if "GET".casecmp(request_type) == 0
      response = conn.get do |request|
        request.url subUrl
        request.params = params
      end
    elsif "POST".casecmp(request_type) == 0
      response = conn.post do |request|
        request.url subUrl
        request.params = params
        request.body = body
      end
    end

    parsed_response = JSON.parse(response.body)

    parsed_response
  end
end
