require 'rails_helper'
# require 'web_scraping/web_scraping_service'
describe 'WebScrapingService' do
  before(:each) do
    @web_scraping_service = WebScraping::WebScrapingService.new
  end
  describe '#search' do
    context 'when multiple results' do
      it 'returns multiple choices' do
        VCR.use_cassette 'imdb/search_multiple_results' do
          expect(@web_scraping_service.search('rambo'))
            .to match_array(
              [
                { name: 'First Blood',
                  year: '1982',
                  image_url: 'https://images-na.ssl-images-amazon.com/images/' \
                  'M/MV5BODBmOWU2YWMtZGUzZi00YzRhLWJjNDAtYTUwNWVkNDcyZmU5XkEy' \
                  'XkFqcGdeQXVyNDk3NzU2MTQ@._V1_UX182_CR0,0,182,268_AL_.jpg',
                  summary: 'Former Green Beret John Rambo is pursued into the' \
                  ' mountains surrounding a small town by a tyrannical sherif' \
                  'f and his deputies, forcing him to survive using his comba' \
                  't skills.',
                  imdb_url: 'http://www.imdb.com//title/tt0083944/?ref_=fn_al' \
                  '_tt_1' },
                { name: 'Rambo',
                  year: '2008',
                  image_url: 'https://images-na.ssl-images-amazon.com/images/' \
                  'M/MV5BMTI5Mjg1MzM4NF5BMl5BanBnXkFtZTcwNTAyNzUzMw@@._V1_UX1' \
                  '82_CR0,0,182,268_AL_.jpg',
                  summary: 'In Thailand, John Rambo joins a group of mercenar' \
                  'ies to venture into war-torn Burma, and rescue a group of ' \
                  'Christian aid workers who were kidnapped by the ruthless l' \
                  'ocal infantry unit.',
                  imdb_url: 'http://www.imdb.com//title/tt0462499/?ref_=fn_al' \
                  '_tt_2' }
              ]

            )
        end
      end
      context 'when results from different types' do
        it 'handles correctly different types' do
          VCR.use_cassette 'imdb/search_different_types' do
          end
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

  describe '#import_movie' do
    context 'everything is ok' do
      it 'imports movie into database' do
        VCR.use_cassette 'imdb/movie_detail' do
          @web_scraping_service.import_movie(
            'title/tt0118715/?ref_=fn_al_tt_1'
          )
          @local_results = Movie.where(name: /The Big Lebowski/i).entries
          @local_movie = @local_results.first
          expect(@local_movie.name).to eq('The Big Lebowski')
        end
      end
    end
  end

  describe '#compose_movie_card' do
    context 'TV series' do
      context 'everything goes fine' do
        it 'creates a movie card' do
          VCR.use_cassette 'imdb/movie_card_series' do
            movie_card = @web_scraping_service.compose_movie_card(
              'title/tt0290978/?ref_=nv_sr_2'
            )
            expect(movie_card[:name]).to eq('The Office')
            expect(movie_card[:image_url]).to eq(
              'https://images-na.ssl-images-amazon.com/images/M/MV5BMTQwOTA3M' \
              'DA4MV5BMl5BanBnXkFtZTcwNDA3MzgyMQ@@._V1._CR28,1,321,451_UY268_' \
              'CR4,0,182,268_AL_.jpg'
            )
            expect(movie_card[:summary]).to eq(
              'The story of an office that faces closure when the company dec' \
              'ides to downsize its branches. A documentary film crew follow ' \
              'staff and the manager David Brent as they continue their daily' \
              ' lives.'
            )
            expect(movie_card[:imdb_url]).to eq(
              'http://www.imdb.com/title/tt0290978/?ref_=nv_sr_2'
            )
          end
        end
      end
    end
    context 'movie' do
      context 'everything goes fine' do
        it 'creates a movie card' do
          VCR.use_cassette 'imdb/movie_card_movie' do
            movie_card = @web_scraping_service.compose_movie_card(
              'title/tt0118715/?ref_=fn_al_tt_1'
            )
            expect(movie_card[:name]).to eq('The Big Lebowski')
          end
        end
      end
    end
  end
  describe '#item_type' do
    context 'type is movie' do
      it 'returns correct type movie' do
        VCR.use_cassette 'imdb/movie_rambo' do
          doc = Nokogiri::HTML(
            open('http://www.imdb.com/title/tt0462499/?ref_=nv_sr_1')
          )
          expect(@web_scraping_service.send(:item_type, doc)).to eql 'movie'
        end
      end
    end
    context 'type is series' do
      it 'returns correct type series' do
        VCR.use_cassette 'imdb/series_modern_family' do
          doc = Nokogiri::HTML(
            open('http://www.imdb.com/title/tt1442437/?ref_=fn_al_tt_1')
          )
          expect(@web_scraping_service.send(:item_type, doc)).to eql 'series'
        end
      end
    end
  end
end
