require 'rails_helper'
# require 'web_scraping/web_scraping_service'
describe 'WebScrapingService' do
  before(:each) do
    @web_scraping_service = WebScraping::WebScrapingService.new
  end
  describe 'search' do
    context 'when multiple results' do
      it 'returns multiple choices' do
        VCR.use_cassette 'imdb/search_multiple_results' do
          expect(@web_scraping_service.search('the big lebowski'))
            .to eq('pop')
        end
      end
    end
  end
end
