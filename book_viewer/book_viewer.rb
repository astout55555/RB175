require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("./data/toc.txt")  
end

# Calls the block for each chapter, passing that chapter's number, name, and
# contents.
def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name, :number, and
# :paragraphs keys. The value for :paragraphs will be a hash of paragraph indexes
# and that paragraph's text.
def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

helpers do
  def highlight(text, substring)
    text.gsub(substring, "<strong>#{substring}</strong>")
  end

  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |paragraph, index|
      "<p id=paragraph#{index}>#{paragraph}</p>"
    end.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  chp_num = params[:number].to_i
  chp_name = @contents[chp_num - 1]
  
  redirect "/" unless (1..@contents.size).cover? chp_num
  
  @title = "Chapter #{chp_num}: #{chp_name}"
  @chapter = File.read("./data/chp#{chp_num}.txt")

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])

  erb :search
end

not_found do
  redirect "/"
end