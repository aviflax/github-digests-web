require 'sinatra'
require 'oauth2'
require 'securerandom'
require 'uri'

enable :sessions

GITHUB_API_CLIENT_ID = '25016e5023978c71e448'
GITHUB_API_SECRET = 'cb2a90c85a6f164ddc94dca828a1878afb897347'

oauth_client = OAuth2::Client.new(GITHUB_API_CLIENT_ID, GITHUB_API_SECRET, :site => 'https://github.com')
token = nil
gh_client = nil

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/oauth2/start' do
  session[:state] = SecureRandom.urlsafe_base64(16)
  redirect_uri = 'http://localhost:4567/oauth2/callback'
  uri = "https://github.com/login/oauth/authorize?client_id=#{GITHUB_API_CLIENT_ID}&redirect_uri=#{URI.encode_www_form_component(redirect_uri)}&scope=notifications&state=#{session[:state]}";
  redirect uri, 307
end

get '/oauth2/callback' do
  code = params[:code]
  state = params[:state]
  puts "CODE " + code
  token = oauth_client.auth_code.get_token(code, :redirect_uri => 'http://localhost:4567/oauth2/callback')
  puts "TOKEN " + token
  gh_client = Octokit::Client.new(:access_token => token)
  puts gh_client.user
  [200, {'Content-Type' => 'text/plain'},  gh_client.user]
end

get '/settings' do
  # TODO: ensure the user is signed in
  send_file File.join(settings.public_folder, 'settings.html')
end

patch '/settings' do
  # TODO: ensure the user is signed in
  # TODO: validate and process the request
  [204, {}, nil]
end
