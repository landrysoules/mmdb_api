module Common
  class UtilService
    def filter_results(local_list, list)
      return [] if list.blank?
      local_name_list = local_list.map { |elt| elt[:name].upcase }
      Rails.logger.warn "++++++ local_name_list: #{local_name_list.inspect}"
      list.reject do |member|
        Rails.logger.warn "----- member: '#{member[:name]}'"
        local_name_list.include?(member[:name].upcase)
      end
    end
  end
end
