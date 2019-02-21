require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'HTTParty'
require 'sinatra/cross_origin'
require 'byebug'
before do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"

  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"
  response.headers["Access-Control-Allow-Origin"] = "*"

end
options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"

  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"
  response.headers["Access-Control-Allow-Origin"] = "*"

  200
end

configure do
  enable :cross_origin
end

before do
  if env["puma.config"].environment == 'development'
    url = 'http://wdi_friends.draketalley.com/api/verify/'
    token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
    opts = {
      "headers": {
        "Authorization": "Bearer #{token}"

      }
    }
    resp = HTTParty.get(url, opts) 
    @user_data = {
      name: resp.headers["x-user-name"],
      email: resp.headers["x-user-email"],
      id: resp.headers["x-user-id"]
    }
  else 
    @user_data = {
      name: env['HTTP_X_USER_NAME'],
      email: env['HTTP_X_USER_EMAIL'],
      id: env['HTTP_X_USER_ID']
    }

  end

  if @user_data[:id].nil? && request.request_method != 'OPTIONS'
    halt 401, "Invalid Token"
  end

end
require './routes';
require './routes/tweet'
