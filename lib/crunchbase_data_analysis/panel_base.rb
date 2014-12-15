# -*- coding: utf-8 -*-
module CrunchbaseDataAnalysis
 class PanelBase < Common
  def get_funding_round(permalink)
    CrunchbaseAcademic::FundingRound.get(permalink)
  end

  def get_product(permalink)
    CrunchbaseAcademic::Product.get(permalink)
  end

  def get_total_num_in_year(items, year)
    total = 0
    for item in items
      if item[:year] == year
        total += 1
      end
    end
    total
  end

  def get_total_price_in_year(items, year)
    total = 0
    for item in items
      if item[:year] == year
        total += items[:price]
      end
    end
    total
  end

  def extract_path(item)
    path ||= item['path']
    if path == nil
      return 0
    elsif path.include?('product')
      return path.slice!(8..-1)
    elsif path.include?('funding-round')
      return path.slice!(14..-1)
    end
  end

  def get_founded_param_array(org_list)
    founded_array = []
    for org in org_list
      founded_array << {permalink: org.permalink, year: nil_guard_for_year(org.founded_on_year)}
    end
    founded_array
  end

  def get_funding_round_array(org_list)
    fund_array = []
    for org in org_list
      for item in org.funding_rounds
        permalink = extract_path(item)
        funding = get_funding_round(permalink)
        fund_array << {price: funding.money_raised_usd, year: nil_guard_for_year(funding.announced_on_year)}
      end
    end
    fund_array
  end

  def get_product_array(org_list)
    product_array = []
    for org in org_list
      for item in org.products
        permalink = extract_path(item)
        product = get_product(permalink)
        product_array << {permalink: product.permalink, year: nil_guard_for_year(product.launched_on_year)}
      end
    end
    product_array
  end

  def get_investment_array(person)
    inv_array = []
    path_list = []
    for inv in person.investments['items']
      path_list << extract(inv['funding_round'])
      for permalink in path_list
        investment = get_funding_round(permalink)
        inv_array = {price: investment.money_raised_usd, year: nil_guard_for_year(investment.announced_on_year)}
      end
    end
    inv_array
  end

  def nil_guard_for_year(value)
    (value ? value : 2007)
  end
 end
end