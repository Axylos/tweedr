require 'sinatra'
require 'sinatra/activerecord'

class Tweet < ActiveRecord::Base
  validates_presence_of :tweet, :author_id
end
