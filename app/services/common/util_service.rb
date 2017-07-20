module Common
  class UtilService
    def filter_results(word, list)
      puts "list: #{list.inspect}"
      return [] if list.blank?
      list.reject do |member|
        puts "#{member[:name]} / #{word}"
        member[:name].casecmp(word).zero?
      end
    end
  end
end
