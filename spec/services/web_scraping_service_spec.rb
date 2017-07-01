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
            .to match_array(
              [
                { name: 'The Big Lebowski',
                  link: '/title/tt0118715/?ref_=fn_al_tt_1' },
                { name: 'The Big Lebowski',
                  link: '/title/tt5802034/?ref_=fn_al_tt_2' },
                { name: 'The Big Lebowski 2',
                  link: '/title/tt1879064/?ref_=fn_al_tt_3' },
                { name: 'The Big Lebowski Live Cast Reunion',
                  link: '/title/tt3265918/?ref_=fn_al_tt_4' },
                { name: 'The Big Lebowski Renactment',
                  link: '/title/tt5021088/?ref_=fn_al_tt_5' },
                { name: 'The Big Lebowski with Jeff Bridges',
                  link: '/title/tt2674312/?ref_=fn_al_tt_6' },
                { name: 'The Big Lebowski - What to Watch Before You Die',
                  link: '/title/tt4521384/?ref_=fn_al_tt_7' },
                { name: 'Big Lebowski',
                  link: '/title/tt1779519/?ref_=fn_al_tt_8' },
                { name: "Om filmen 'The Big Lebowski'",
                  link: '/title/tt1229613/?ref_=fn_al_tt_9' }
              ]
            )
        end
      end
    end
  end
end
