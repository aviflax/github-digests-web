require 'sinatra'
require 'securerandom'
require 'uri'
require 'restclient'
require 'octokit'

enable :sessions

GITHUB_API_CLIENT_ID = '25016e5023978c71e448'
GITHUB_API_SECRET = 'cb2a90c85a6f164ddc94dca828a1878afb897347'

gh_client = nil

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/oauth2/start' do
  session[:state] = SecureRandom.urlsafe_base64(16)
  redirect_uri = 'http://localhost/oauth2/callback'
  uri = "https://github.com/login/oauth/authorize?client_id=#{GITHUB_API_CLIENT_ID}&redirect_uri=#{URI.encode_www_form_component(redirect_uri)}&scope=notifications,user&state=#{session[:state]}";
  redirect uri, 307
end

get '/oauth2/callback' do
  code = params[:code]
  state = params[:state]

  if state != session[:state]
    redirect '/settings', 307
  end

  result = RestClient.post('https://github.com/login/oauth/access_token',
                            {:client_id => GITHUB_API_CLIENT_ID,
                             :client_secret => GITHUB_API_SECRET,
                             :code => code},
                             :accept => :json)

  # TODO: handle failure
  # TODO: confirm that we have access to the scopes we need — see https://developer.github.com/guides/basics-of-authentication/#checking-granted-scopes

  session[:token] = JSON.parse(result)['access_token']

  redirect '/settings', 307
end

get '/settings', :provides => 'html' do
  # TODO: confirm that we can successfully retrieve data from the GH API using the token
  # gh_client = Octokit::Client.new(:access_token => session[:token])

  # TODO: confirm that we have access to the scopes we need — see https://developer.github.com/guides/basics-of-authentication/#checking-granted-scopes

  unless session[:token]
    redirect '/', 307
  end

  send_file File.join(settings.public_folder, 'settings.html')
end

get '/settings', :provides => 'json' do
  # TODO: confirm that we can successfully retrieve data from the GH API using the token
  # gh_client = Octokit::Client.new(:access_token => session[:token])

  unless session[:token]
    redirect '/', 307
  end

  '{"nothing": "yet"}'
end

patch '/settings' do
  # TODO: ensure the user is signed in
  # TODO: validate and process the request
  [204, nil]
end
