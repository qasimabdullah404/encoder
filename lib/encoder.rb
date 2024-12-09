require "sinatra"
require "sinatra/cross_origin"
require "json"
require "base64"

configure do
  enable :cross_origin
end

before do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
end

helpers do
  # Helper to format JSON responses
  def json_response(status, data = nil, error = nil)
    { status: status, data: data, error: error }.to_json
  end
end

get "/api/encode/:string" do
  begin
    encoded = Base64.strict_encode64(params[:string])
    json_response('SUCCESS', encoded)
  rescue => e
    json_response('ERROR', nil, "Encoding failed: #{e.message}")
  end
end

get "/api/decode/:string" do
  begin
    decoded = Base64.strict_decode64(params[:string])
    json_response('SUCCESS', decoded)
  rescue ArgumentError => e
    json_response('ERROR', nil, "Decoding failed: #{e.message}")
  rescue => e
    json_response('ERROR', nil, "An unexpected error occurred: #{e.message}")
  end
end

get "/uptime" do
  json_response('UP', "Encoder lives #{Time.now}")
end
