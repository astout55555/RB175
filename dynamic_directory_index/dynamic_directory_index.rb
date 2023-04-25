require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @filenames = Dir.glob("./public/*").map { |file| File.basename(file) }.sort
  @filenames.reverse! if params[:sort] == 'descending'
  erb :listing_page
end
