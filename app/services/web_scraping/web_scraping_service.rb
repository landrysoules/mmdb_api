require 'open-uri'
module WebScraping
  class WebScrapingService
    def initialize
      @base_url_imdb = 'http://www.imdb.com'
    end

    def search(query)
      movies = []
      formatted_query = CGI.escape query
      doc = Nokogiri::HTML(
        open("#{@base_url_imdb}/find?ref_=nv_sr_fn&q=#{formatted_query}&s=all")
      )
      table = doc.xpath('//*[@id="main"]/div/div[2]/table')
      table.search('tr').each do |tr|
        cells = tr.search('td')
        link = cells[1].first_element_child
        movies << { name: link.children[0].text, link: link['href'] }
      end
      movies
    end
  end
end
