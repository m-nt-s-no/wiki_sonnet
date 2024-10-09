require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "nokogiri"
require "openai"

get("/") do
  erb(:form)
end

get("/test") do
  title = params.fetch("article_title")
  formatted_title = title.gsub(" ", "%20")
  url = "https://en.wikipedia.org/w/api.php?action=parse&page=#{formatted_title}&format=json"
  http_response = HTTP.get(url)
  parsed_response = JSON.parse(http_response)
  parse = parsed_response.fetch("parse")
  text = parse.fetch("text")
  star_text = text.fetch("*")

  parsed_text = Nokogiri::HTML(@star_text)
  p_text = parsed_text.search('p')
  first_p = p_text.slice(1)

  client = OpenAI::Client.new(access_token: ENV.fetch("OPEN_AI_KEY"))
  message_list = [
    {
      "role" => "system",
      "content" => "You are a helpful assistant who can turn any text into a Shakespearean sonnet."
    },
    {
      "role" => "user",
      "content" => "#{first_p}"
    }
  ]

  api_response = client.chat(
    parameters: {
    model: "gpt-3.5-turbo",
    messages: message_list
    }
  )

  @sonnet = api_response["choices"][0]["message"]["content"]

  erb(:test)
end
