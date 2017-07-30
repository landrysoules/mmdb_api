require 'rails_helper'
# require 'web_scraping/web_scraping_service'
describe 'WebScrapingService' do
  before(:each) do
    @web_scraping_service = WebScraping::WebScrapingService.new
  end
  describe '#search' do
    context 'when multiple results' do
      xit 'returns multiple choices' do
        VCR.use_cassette 'imdb/search_multiple_results' do
          expect(@web_scraping_service.search('the big lebowski'))
            .to match_array(
              [
                { name: 'The Big Lebowski',
                  link: '/title/tt0118715/?ref_=fn_al_tt_1',
                  image: 'https://images-na.ssl-images-amazon.com/images/M/MV5BZTFjMjBiYzItNzU5YS00MjdiLWJkOTktNDQ3MTE3ZjY2YTY5XkEyXkFqcGdeQXVyNDk3NzU2MTQ@._V1_UX32_CR0,0,32,44_AL_.jpg' },
                { name: 'The Big Lebowski',
                  link: '/title/tt5802034/?ref_=fn_al_tt_2',
                  image: 'https://images-na.ssl-images-amazon.com/images/M/MV5BYzExM2E4OWItNTBmYS00MDdhLTgyNzQtY2ZmZWI0MjAwOTgyXkEyXkFqcGdeQXVyMjUxNzg3MDI@._V1_UX32_CR0,0,32,44_AL_.jpg' },
                { name: 'The Big Lebowski 2',
                  link: '/title/tt1879064/?ref_=fn_al_tt_3',
                  image: 'https://images-na.ssl-images-amazon.com/images/M/MV5BYzExM2E4OWItNTBmYS00MDdhLTgyNzQtY2ZmZWI0MjAwOTgyXkEyXkFqcGdeQXVyMjUxNzg3MDI@._V1_UX32_CR0,0,32,44_AL_.jpg' },
                { name: 'The Big Lebowski Live Cast Reunion',
                  link: '/title/tt3265918/?ref_=fn_al_tt_4',
                  image: nil },
                { name: 'The Big Lebowski Renactment',
                  link: '/title/tt5021088/?ref_=fn_al_tt_5',
                  image: nil },
                { name: 'The Big Lebowski with Jeff Bridges',
                  link: '/title/tt2674312/?ref_=fn_al_tt_6',
                  image: nil },
                { name: 'The Big Lebowski - What to Watch Before You Die',
                  link: '/title/tt4521384/?ref_=fn_al_tt_7',
                  image: nil },
                { name: 'Big Lebowski',
                  link: '/title/tt1779519/?ref_=fn_al_tt_8',
                  image: nil },
                { name: "Om filmen 'The Big Lebowski'",
                  link: '/title/tt1229613/?ref_=fn_al_tt_9',
                  image: 'https://images-na.ssl-images-amazon.com/images/M/MV5BMDE2MmI4MmMtMGQ0Ni00OGEzLTg5ODEtNmY2ZTViMjc3NzUwXkEyXkFqcGdeQXVyMTQzMjU1NjE@._V1_UY44_CR16,0,32,44_AL_.jpg' }
              ]
            )
        end
      end
    end
    context 'when results both local and imdb' do
      it 'returns results from both sources' do
        movie = create :pusher
        Rails.logger.debug "movie: #{movie.inspect}"
        Rails.logger.debug "movies from db: #{Movie.first.inspect}"
        mmdb_results = Movie.where(name: /.*pusher.*/i).all.to_a
        Rails.logger.debug "mmdb_results: #{mmdb_results.inspect}"
        imdb_results = @web_scraping_service.search('pusher')
        Rails.logger.debug "imdb_results: #{imdb_results.inspect}"
        mmdb_results << imdb_results
        puts mmdb_results.inspect
      end
      it 'returns only imdb results with name not in mmdb_results' do

      end
    end
    context 'when results only imdb' do

    end
    context 'when results only mmdb' do

    end
  end
end
