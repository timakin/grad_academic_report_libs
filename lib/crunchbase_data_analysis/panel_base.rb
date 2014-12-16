# -*- coding: utf-8 -*-
require_relative 'common.rb'
module CrunchbaseDataAnalysis
 class PanelBase < Common
  def get_funding_round(permalink)
    CrunchbaseAcademic::FundingRound.get(permalink)
  end

  def get_product(permalink)
    CrunchbaseAcademic::Product.get(permalink)
  end

  def get_total_num_in_year(items, year)
    p "get_total_num_in_year"
    total = 0
    if items.empty?
      return 0      
    else
      p items
      for item in items
        if item[:year] < 2007
          item[:year] = 2007
        end
        if item[:year] == year
          total += 1
        end
      end
      return total
    end
  end

  def get_total_price_in_year(items, year)
    p "get_total_price_in_year"
    total = 0
    if items.empty?
      return 0
    else
      for item in items
        if item[:year] < 2007
          item[:year] = 2007
        end
        if item[:year] == year
          total += nil_addition_guard(item[:price])
        end
      end
      return total
    end
  end

  def extract_path(item)
    p "extract_path"
    if Array(item['path']).empty?
      return 0
    else
      path ||= item['path']
    end

    if path == nil
      return 0
    elsif path.include?('product')
      return path.slice!(8..-1)
    elsif path.include?('funding-round')
      return path.slice!(14..-1)
    end
  end

  def get_founded_param_array(org_list)
    p "get_founded_param_array"
    founded_array = []
    for org in org_list
      founded_array << {year: nil_guard_for_year(org.founded_on_year)}
    end
    founded_array
  end

  def get_funding_round_array(org_list)
    p "get_funding_round_array"
    fund_array = []
    for org in org_list
      if org.funding_rounds.nil?
        return []
      else
        for item in org.funding_rounds['items']
          permalink = extract_path(item)
          funding = get_funding_round(permalink)
          fund_array << {price: funding.money_raised_usd, year: nil_guard_for_year(funding.announced_on_year)}
        end
      end
    end
    fund_array
  end

  def get_product_array(org_list)
    p "get_product_array"
    product_array = []
    for org in org_list
      if org.products.nil?
        return []
      else
        for item in org.products
          permalink = extract_path(item)
          product = get_product(permalink)
          product_array << {year: nil_guard_for_year(product.launched_on_year)}
        end
      end
    end
    product_array
  end

  def get_investment_array(person)
    p "get_investment_array"
    inv_array = []
    path_list = []
    if person.investments.nil?
      return []
    else
      for inv in person.investments['items']
        path_list << extract_path(inv['funding_round'])
        for permalink in path_list
          investment = get_funding_round(permalink)
          inv_array << {price: investment.money_raised_usd, year: nil_guard_for_year(investment.announced_on_year)}
        end
      end
    end
    inv_array
  end

  def nil_guard_for_year(value)
    (value ? value : 2007)
  end
 end
end