require 'rails_helper'
# require 'web_scraping/web_scraping_service'
describe 'UtilService' do
  before(:each) do
    @util_service = Common::UtilService.new
    @remote_list = [{ name: 'Rambo' }, { name: 'Platoon' }, { name: 'Cocoon' }]
  end
  describe '#filter_results' do
    context 'no results parameter' do
      it 'returns []' do
        expect(@util_service.filter_results('dummy movie', nil))
          .to eq []
      end
    end
    context '1 movie already present' do
      it 'returns unchanged list' do
        expect(@util_service
        .filter_results('Rambo', @remote_list))
          .to eq [{ name: 'Platoon' }, { name: 'Cocoon' }]
      end
    end
  end
end
