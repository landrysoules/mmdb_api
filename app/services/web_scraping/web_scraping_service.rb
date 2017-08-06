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
      # table = doc.xpath('//*[@id="main"]/div/div[2]/table')
      table = doc.css('table.findList')[0]
      table.search('tr').each do |tr|
        cells = tr.search('td')
        # image = cells[0].first_element_child.first_element_child
        link = cells[1].first_element_child
        movies << compose_movie_card(link['href'])
      end
      Rails.logger.info("movies: #{movies.inspect}")
      movies
    end

    def import_movie(url)
      doc = Nokogiri::HTML(
        open("#{@base_url_imdb}/#{url}")
      )
      name_year = doc.css("h1[itemprop='name']").text
      /(?<name>.+)\((?<year>.+)\)/ =~ name_year
      # p name
      name = name.tr("\u00A0", ' ').strip
      Movie.create!(name: name, year: year)
    end

    def compose_movie_card(url)
      imdb_url = "#{@base_url_imdb}/#{url}"
      Rails.logger.info "compose movie card for url: #{imdb_url}"
      doc = Nokogiri::HTML(
        open(imdb_url)
      )
      if doc.css('span#titleYear').present?
        compose_movie_card_movie(doc, imdb_url)
      else
        compose_movie_card_series(doc, imdb_url)
      end
    end

    private

    def compose_movie_card_movie(doc, imdb_url)
      name_year = retrieve_name_year(doc.css("h1[itemprop='name']").text)
      image_url = doc.css('div.poster img').attr('src').value
      summary = doc.css('div.summary_text').text.tr("\u00A0", ' ').strip
      {
        name: name_year[:name],
        year: name_year[:year],
        image_url: image_url,
        summary: summary,
        imdb_url: imdb_url
      }
    end

    def compose_movie_card_series(doc, imdb_url)
      name = doc.css("h1[itemprop='name']").text.tr("\u00A0", ' ').strip
      image_url = doc.css('div.poster img').attr('src').value
      summary = doc.css('div.summary_text').text.tr("\u00A0", ' ').strip
      {
        name: name,
        image_url: image_url,
        summary: summary,
        imdb_url: imdb_url
      }
    end

    def retrieve_name_year(text)
      p text
      /(?<name>.+)\((?<year>.+)\)/ =~ text
      name = name.tr("\u00A0", ' ').strip
      { name: name, year: year }
    end
  end
end
