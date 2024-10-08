require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "nokogiri"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
  url = "https://en.wikipedia.org/w/api.php?action=parse&page=Tom%20Cruise&format=json"
  http_response = HTTP.get(url)
  parsed_response = JSON.parse(http_response)
  parse = parsed_response.fetch("parse")
  text = parse.fetch("text")
  @star_text = text.fetch("*")
  splits = @star_text.split
  splits.length.times do |num| #this is awful...I'd much rather get Nokogiri to work
    if splits[num].include? "age&#160;"
      @age = splits[num].to_s
    end
  end
  #parsed_text = Nokogiri::HTML(star_text)
  #@age = parsed_text.at('span class=\"bday\"').text #getting errors for diff search strings
  #puts @age
  erb(:test)
end
