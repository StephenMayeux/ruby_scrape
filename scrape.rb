require 'rubygems'
require 'mechanize'

Movie = Struct.new(:title, :yeat, :summary)

found_movies = []

# We get identified with the User-Agent String
agent = Mechanize.new do |agent|
  agent.user_agent_alias = "Windows Chrome"
end

# submit form
agent.get("http://afi.com/search/") do |page|
  results = page.form_with(:class => "gsc-search-box") do |search|
    search.SearchText = "Godfather"
  end.submit

  # gather link results that follow regex pattern
  results.link_with(:href => /DetailView.aspx\?s=\&Movie=/).each do |link|
    current_movie = Movie.new
    # grab year text from each link
    current_movie.year = link.text.match(/\(\d{4}\)$/)[0].gsub(/\D/, "")
    description_page = link.click

    # get the movie title via XPath expression, text that is centered and bold
    description_page.search("//center//b").each do |node|
      current_movie.title = node.text.strip
    end

    # if available, get summary, which might be in a table
    description_page.search("//td/tr[contains(., 'Summary:')]/td[2]").each do |node|
      if ((node.text =~ /\w/))
        current_movie.summary = node.text.strip
      end
    end
  end
end
