require 'dotenv'
Dotenv.load

require 'json'
require 'securerandom'
require 'uri'

require 'sinatra'
require 'restclient'
require 'octokit'

require_relative './db'
require_relative './settings'

enable :sessions

GITHUB_API_CLIENT_ID = ENV['GITHUB_API_CLIENT_ID']
GITHUB_API_SECRET = ENV['GITHUB_API_SECRET']

helpers do
  def protected!
    unless session[:token]
      redirect '/', 307
    end
  end
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/oauth2/start' do
  session[:state] = SecureRandom.urlsafe_base64(16)
  redirect_uri = 'http://localhost/oauth2/callback'
  uri = "https://github.com/login/oauth/authorize?client_id=#{GITHUB_API_CLIENT_ID}&redirect_uri=#{URI.encode_www_form_component(redirect_uri)}&scope=notifications,user:email,read:org&state=#{session[:state]}"
  redirect uri, 307
end

get '/oauth2/callback' do
  code = params[:code]
  state = params[:state]

  if state != session[:state]
    # TODO: this could maybe lead to an infinite redirection loop. perhaps it would be better to just return an error response
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

  gh_client = Octokit::Client.new(:access_token => session[:token])
  user = gh_client.user

  if not DB.account_exists?(user.id)
    settings = initial_settings(user, gh_client.orgs, gh_client.emails)
    DB.create_account(user.id, session[:token], settings)
  end

  # TODO: if the account already exists, check if its email addresses have
  # changed and if so do something about it

  # Cache the user ID in the session for improved performance and etc.
  session[:user_id] = user.id

  redirect '/settings', 307
end

get '/settings' do
  protected!
  # TODO: confirm that we have access to the scopes we need — see https://developer.github.com/guides/basics-of-authentication/#checking-granted-scopes
  send_file File.join(settings.public_folder, 'settings.html')
end

get '/account/settings', :provides => 'json' do
  protected!
  DB.get_settings(session[:user_id]).to_json
end

patch '/account/settings' do
  protected!
  # TODO: validate and process the request
  # TODO: actually update the actual data, actually
  [204, nil]
end

delete '/account' do
  protected!
  DB.delete_account(session[:user_id])

  # TODO: a cleaner way to clear the session. like a clear_session fn maybe.
  session[:user_id] = nil
  session[:token] = nil

  [204, nil]
end
