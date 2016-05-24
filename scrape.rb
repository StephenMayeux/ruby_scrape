require 'rubygems'
require 'mechanize'

Movie = Struct.new(:title, :yeat, :summary)

# We get identified with the User-Agent String
agent = Mechanize.new do |agent|
  agent.user_agent_alias = "Windows Chrome"
end

page = agent.get("http://afi.com/search/") do |page|
  results = page.form_with(:name => "Search") do |search|
    search.SearchText = "Godfather"
  end.submit
end
