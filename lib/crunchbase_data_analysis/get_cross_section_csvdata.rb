# -*- coding: utf-8 -*-
require 'csv'
module CrunchbaseDataAnalysis
  class GetCrossSectionCsvdata < Common
    def generate_data
      cross_path = File.expand_path('crunchbase_data_analysis/results/cross_section_data.csv')
      permalink_path = File.expand_path('crunchbase_data_analysis/crunchbase_data/permalink.csv')
      CSV.open(cross_path, 'w') do |row|
        row << ['permalink', 'fr_sum', 'serial_num', 'vp_exp_dummy', 'num_comp_exp', 'product_num', 'num_news', 'inv_num', 'cs_dummy', 'biz_dummy', 'master_dummy', 'age']
        CSV.foreach(permalink_path) do |rawlink|
          p "======================"
          person = get_person(rawlink[0])
          next if not_founder_flag(person) == 1
          puts "Founder flag passed"
          org_list = founded_org_path_list(person)
          row << [person.permalink, total_funding(org_list), serial_num(person), vp_flag(person), count_of_exp(person), count_of_product(org_list), count_of_news(org_list), inv_num(person), cs_flag(person), biz_flag(person), master_flag(person), get_age(person)]
        end
      end
    end
  end
end