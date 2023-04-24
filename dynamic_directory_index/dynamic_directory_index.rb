require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  # @filenames = 
  erb :listing_page
end
