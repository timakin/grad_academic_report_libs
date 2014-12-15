# -*- coding: utf-8 -*-
require 'csv'
module CrunchbaseDataAnalysis
  class GetPanelCsvdata < PanelBase
    def generate_data


      panel_path = File.expand_path('crunchbase_data_analysis/results/panel_data.csv')
      permalink_path = File.expand_path('crunchbase_data_analysis/crunchbase_data/permalink.csv')
      CSV.open(panel_path, 'a') do |row|
        row << ['permalink', 'year', 'fr_sum', 'serial_num', 'vp_exp_dummy', 'num_comp_exp', 'product_num', 'inv_num', 'cs_dummy', 'biz_dummy', 'master_dummy']
        CSV.foreach(permalink_path) do |rawlink|
          p "======================"
          person = get_person(rawlink[0])
          p person.permalink
          next if not_founder_flag(person) == 1
          puts "Founder flag passed"
          org_list = founded_org_path_list(person)
          funding_array = get_funding_round_array(org_list)
          founded_array = get_founded_param_array(org_list)
          product_array = get_product_array(org_list)
          inv_array = get_investment_array(person)
          serial_num = 0
          total_product_num = 0
          total_inv_num = 0

          (2007..2014).each do |year|
            serial_num = serial_num + get_total_num_in_year(founded_array, year)
            total_product_num = total_product_num + get_total_num_in_year(product_array, year)
            total_inv_num = total_inv_num + get_total_num_in_year(inv_array, year)
            row << [person.permalink, year, get_total_price_in_year(funding_array), serial_num, vp_flag(person), count_of_exp(person), total_product_num, total_inv_num, cs_flag(person), biz_flag(person), master_flag(person)]
            sleep(5)
          end
        end
      end
    end


  end
end
