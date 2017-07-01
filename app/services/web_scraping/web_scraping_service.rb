module WebScraping
  class WebScrapingService
    def search(query)
      Wombat.crawl do
        base_url 'http://www.imdb.com'
        path '/find?ref_=nv_sr_fn&q=the+big+lebowski&s=all'
        what_is({ css: '#main > div > div:nth-child(3) > table'}, :list)
        # headline xpath: '//h1'
        # subheading css: 'p.alt-lead'
        #
        # what_is({ css: '.one-fourth h4' }, :list)
        #
        # links do
        #   explore xpath: '/html/body/header/div/div/nav[1]/a[4]' do |e|
        #     e.gsub(/Explore/, 'Love')
        #   end
        #
        #   features css: '.nav-item-opensource'
        #   business css: '.nav-item-business'
        # end
      end
    end
  end
end
