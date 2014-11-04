# -*- coding: utf-8 -*-
require 'csv'
module CrunchbaseDataAnalysis
  class GetCrossSectionCsvdata < Common
    def generate_data
      CSV.open("../../results/cross_section_data.csv", 'w') do |row|
        row << ['permalink', 'fr_sum', 'serial_dummy', 'vp_exp_dummy', 'num_comp_exp', 'product_num', 'num_news', 'inv_dummy', 'cs_dummy', 'biz_dummy', 'master_dummy', 'age']
        CSV.foreach("../../crunchbase_data/permalink.csv") do |link|
          next if not_founder_flag(link)
          org_list = founded_org_path_list(link)
          row << [link, total_funding(org_list), serial_flag(link), vp_flag(link), count_of_exp(link), count_of_product(org_list), count_of_news(org_list), inv_flag(link), cs_flag(link), biz_flag(link), master_flag(link), get_age(link)]
        end
      end
    end
  end
end