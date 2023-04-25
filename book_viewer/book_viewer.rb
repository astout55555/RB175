require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("../data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  @contents = File.readlines("../data/toc.txt")
  @chp_num = params[:number].to_i
  @chp_name = @contents[@chp_num - 1]
  @title = "Chapter #{@chp_num}: #{@chp_name}"
  @chapter = File.read("../data/chp#{@chp_num}.txt")

  erb :chapter
end

get "/show/:name" do
  "<h1>#{params[:name]}</h1>"
end
