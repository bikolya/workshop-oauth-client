require 'sinatra/base'
require 'httparty'
require 'json'

class OAuthFoursquare < Sinatra::Base
  CLIENT_ID = "XM0GA5B502NZFRWLT1FRRUH0IFKBTSTD3SVYJLFMTFKS3VSN"
  CLIENT_SECRET = "GFKBO5GYASON4NK42WBYUVBVTCNFNLYH2LK5JZ1F1N50MMU4"
  REDIRECT_URI = "http://localhost:9292/callback"
  AUTH_URL = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"

  enable :sessions

  get '/login' do
    "<a href=#{AUTH_URL}> Auth via Foursquare </a>"
  end

  get '/' do
    resp = HTTParty.get(
      "https://api.foursquare.com/v2/users/self/tips",
      query: {
        oauth_token: session[:token],
        v: "20161122"
      }
    )
    data = JSON.parse(resp.body)
    erb :index, locals: { tips: data['response']['tips']['items'] }
  end

  get '/explore' do
    resp = HTTParty.get(
      "https://api.foursquare.com/v2/venues/explore",
      query: {
        near: 'Moscow, Russia',
        oauth_token: session[:token],
        v: "20161122"
      }
    )
    data = JSON.parse(resp.body)
    erb :explore, locals: { venues: data['response']['groups'].first['items'] }
  end

  get '/callback' do
    resp = HTTParty.get(
      "https://foursquare.com/oauth2/access_token",
      query: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type: "authorization_code",
        redirect_uri: REDIRECT_URI,
        code: params[:code]
      }
    )
    hash = JSON.parse(resp.body)
    session[:token] = hash['access_token']
    redirect '/'
  end
end
