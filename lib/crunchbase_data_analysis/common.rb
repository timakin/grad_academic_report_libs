# -*- coding: utf-8 -*-
require 'crunchbase_academic'
require 'date'

module CrunchbaseDataAnalysis
 class Common
  CrunchbaseAcademic::API.key = 'e623b14ba10c2f7a0a2c99b2da892569'
  @@cs_list = ['CS', 'Computer Science', 'Engineering']
  @@biz_list = ['E-Commerce', 'Economics', 'Business', 'BS', "Marketing", "Entrepreneur", "Management", "Finance", "Accounting"]
  @@master_list = ['Master', 'MS']


  def get_person(permalink)
    CrunchbaseAcademic::Person.get(permalink)
  end  

  def get_org(orgname)
    CrunchbaseAcademic::Organization.get(orgname)
  end

  def get_total_num(list)
    p "get_total_num"
    total = (list ? list['paging']['total_items'] : 0)
  end

  def get_age(person)
    p "get_age"
    if person.born_on_year.nil?
      age = 25
    elsif
      birthyear = person.born_on_year
      thisyear = Date.today.year
      age = thisyear - birthyear
    end
    age
  end

  def bool_to_int(condition)
    (condition ? 1 : 0)
  end

  def nil_addition_guard(value)
    (value ? value : 0)
  end

  def founded_org_path_list(person, raw_org_list=[], result_org_list=[])
    p "founded_org_path_list"
    items = person.founded_company['items']
    items.each do |founded|
      raw_org_list << (founded['path']).slice!(13..-1)
    end
    raw_org_list.compact.each do |org|
      result_org_list << get_org(org)
    end
    result_org_list
  end

  def count_of_exp(person)
    p "count_of_exp"
    experience_of_person = person.experience
    total_count_of_exp_org = get_total_num(experience_of_person)
  end

  def not_founder_flag(person)
    p "not_founder_flag"
    condition = person.founded_company.nil?
    bool_to_int(condition) 
  end

  def serial_flag(person)
    p "serial_flag"
    num_of_founded = get_total_num(person.founded_company)
    condition = !!(num_of_founded >= 2)
    bool_to_int(condition)
  end

  def vp_flag(person)
    p "vp_flag"
    condition = !person.advisor_at.nil?
    bool_to_int(condition)
  end

  def inv_flag(person)
    p "inv_flag"
    condition = !person.investments.nil?
    bool_to_int(condition)
  end

  def biz_flag(person)
    p "biz_flag"
    list = degree_sub_list(person)
    degree_flag_loop(list, @@biz_list)
  end

  def cs_flag(person)
    p "cs_flag"
    list = degree_sub_list(person)
    degree_flag_loop(list, @@cs_list)
  end

  def master_flag(person)
    p "master_flag"
    list = degree_type_list(person)
    degree_flag_loop(list, @@master_list)
  end

  def degree_flag_loop(list, degree_class_array)
    return 0 if list.empty?
    for item in list
      for deg in degree_class_array
        condition = bool_to_int(item.include?(deg))
        break if condition == 1
      end
      break if condition == 1
    end
    condition
  end

  def degree_sub_list(person, list=[])
    degree_param = (!person.degrees.nil? ? person.degrees['items'] : [])
    degree_param.each do |deg|
      subject ||= deg['degree_subject']
      list << subject
    end
    list.compact
  end

  def degree_type_list(person, list=[])
    degree_param = (!person.degrees.nil? ? person.degrees['items'] : [])
    degree_param.each do |deg|
      type_name ||= deg['degree_type_name']
      list << type_name
    end
    list.compact
  end

  def total_funding(org_list, total = 0)
    p "total_funding"
    org_list.each do |org|
      total += nil_addition_guard(org.total_funding_usd)
    end
    total
  end

  def count_of_product(org_list, total = 0)
    p "count_of_product"
    org_list.each do |org|
      total += nil_addition_guard(get_total_num(org.products))
    end
    total
  end

  def count_of_news(org_list, total = 0)
    p "count_of_news"
    org_list.each do |org|
      total += nil_addition_guard(get_total_num(org.news))
    end
    total
  end
 end
end