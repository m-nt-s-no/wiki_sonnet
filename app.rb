require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
  url = "http://en.wikipedia.org/w/api.php?action=parse&page=Tom%20Cruise&format=json"
  http_response = HTTP.get(url) #what is this returning?
  parsed_response = JSON.parse(http_response) #getting JSON::ParserError at / unexpected token at ''
  parse = parsed_response.fetch("parse")
  @text = parse.fetch("text")
  
  erb(:test)
end
