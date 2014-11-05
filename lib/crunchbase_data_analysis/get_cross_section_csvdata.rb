# -*- coding: utf-8 -*-
require 'csv'
module CrunchbaseDataAnalysis
  class GetCrossSectionCsvdata < Common
    def generate_data
      cross_path = File.expand_path('crunchbase_data_analysis/results/cross_section_data.csv')
      permalink_path = File.expand_path('crunchbase_data_analysis/crunchbase_data/permalink.csv')
      CSV.open(cross_path, 'w') do |row|
        row << ['permalink', 'fr_sum', 'serial_dummy', 'vp_exp_dummy', 'num_comp_exp', 'product_num', 'num_news', 'inv_dummy', 'cs_dummy', 'biz_dummy', 'master_dummy', 'age']
        CSV.foreach(permalink_path) do |rawlink|
          p "======================"
          link = get_person(rawlink[0])
          next if not_founder_flag(link) == 1
          puts "Founder flag passed"
          org_list = founded_org_path_list(link)
          row << [link.permalink, total_funding(org_list), serial_flag(link), vp_flag(link), count_of_exp(link), count_of_product(org_list), count_of_news(org_list), inv_flag(link), cs_flag(link), biz_flag(link), master_flag(link), get_age(link)]
        end
      end
    end
  end
end