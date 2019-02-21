current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file   }
require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'byebug'

def parse_body
  begin
    JSON.parse request.body.read
  rescue JSON::ParserError
    halt 422, "Invalid JSON post body"
  end
end

namespace '/api/tweets' do
  get '/' do
    json Tweet.all.index_by &:id
  end

  post '/' do
    begin
      body = parse_body
      tweet = Tweet.new body
    rescue ActiveModel::UnknownAttributeError => err
      halt 422, err.message.to_s
    end
    tweet.author_id = @user_data[:id]
    if tweet.save
      json tweet
    else
      halt 422, tweet.errors.full_messages.to_s
    end
  end

  delete '/:id/' do
    begin
    tweet = Tweet.find(params["id"])
    rescue ActiveRecord::RecordNotFound => err
      halt 404, err.message
    end
    if tweet.author_id == @user_data[:id]
      json tweet.destroy!
    else
      halt 401, "Unable to delete another user's tweet"
    end
  end
  put '/:id/' do
    begin
    tweet = Tweet.find(params["id"])
    rescue ActiveRecord::RecordNotFound => err
      halt 404, err.message
    end
    if tweet.author_id == @user_data[:id]
      body = parse_body
      tweet.update! body
      json tweet
    else
      halt 401, "Unable to update another user's tweet"
    end
  end

end

get '/api/user/tweets/' do
  json Tweet.where(author_id: @user_data[:id]).all.index_by &:id
end

