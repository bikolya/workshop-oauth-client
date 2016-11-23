require 'sinatra/base'
require 'httparty'
require 'json'

class OAuthFoursquare < Sinatra::Base
  CLIENT_ID = "52660e807dcc2fb72d31df8c780f8805fb92fbecb00d2789cfa7282ed29160bc"
  CLIENT_SECRET = "03e82b73fd7f2fc6c11e95680193de40ebcda178b53a1b793eb324bbeb5e5321"
  REDIRECT_URI = "http://localhost:9292/callback"
  AUTH_URL = "http://localhost:3000/oauth/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"

  enable :sessions

  get '/login' do
    "<a href=#{AUTH_URL}> Auth via My Foursquare </a>"
  end

  get '/explore' do
    redirect '/login' unless session[:token]

    resp = HTTParty.get(
      "http://localhost:3000/api/venues",
      headers: {
        Authorization: "Bearer #{session[:token]}"
      }
    )
    data = JSON.parse(resp.body)
    erb :explore, locals: { venues: data }
  end

  get '/callback' do
    resp = HTTParty.post(
      "http://localhost:3000/oauth/token",
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

  get '/' do
    redirect '/login' unless session[:token]

    resp = HTTParty.get(
      "http://localhost:3000/api/me/",
      headers: {
        Authorization: "Bearer #{session[:token]}"
      }
    )
    resp.body
  end
end
