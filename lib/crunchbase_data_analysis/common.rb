# -*- coding: utf-8 -*-
require 'crunchbase_academic'
require 'date'

module CrunchbaseDataAnalysis
 class Common
  CrunchbaseAcademic::API.key = 'e623b14ba10c2f7a0a2c99b2da892569'
  @@cs_list = ['CS', 'Computer Science', 'Engineering']
  @@biz_list = ['E-Commerce', 'Economics', 'Business', 'BS', "Marketing", "Entrepreneur", "Management"]
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

  def get_age(permalink)
    p "get_age"
    person = get_person(permalink)
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

  def founded_org_path_list(permalink, org_list=[])
    p "founded_org_path_list"
    person = get_person(permalink)
    items = person.founded_company['items']
    items.each do |founded|
      org_list << (founded['path']).slice!(13..-1)
    end
    org_list.compact
  end

  def count_of_exp(permalink)
    p "count_of_exp"
    person = get_person(permalink)
    experience_of_person = person.experience
    total_count_of_exp_org = get_total_num(experience_of_person)
  end

  def not_founder_flag(permalink)
    p "not_founder_flag"
    person = get_person(permalink)
    condition = person.founded_company.nil?
    bool_to_int(condition) 
  end

  def serial_flag(permalink)
    p "serial_flag"
    person = get_person(permalink)
    num_of_founded = get_total_num(person.founded_company)
    condition = !!(num_of_founded >= 2)
    bool_to_int(condition)
  end

  def vp_flag(permalink)
    p "vp_flag"
    person = get_person(permalink)
    condition = !person.advisor_at.nil?
    bool_to_int(condition)
  end

  def inv_flag(permalink)
    p "inv_flag"
    person = get_person(permalink)
    condition = !person.investments.nil?
    bool_to_int(condition)
  end

  def biz_flag(permalink)
    p "biz_flag"
    list = degree_sub_list(permalink)
    for biz in @@biz_list
      condition = bool_to_int(list.include?(biz))
      break if condition
    end
    condition
  end

  def cs_flag(permalink)
    p "cs_flag"
    list = degree_sub_list(permalink)
    for cs in @@cs_list
      condition = bool_to_int(list.include?(cs))
      break if condition
    end
    condition
  end

  def master_flag(permalink)
    p "master_flag"
    list = degree_type_list(permalink)
    for master in @@master_list
      condition = bool_to_int(list.include?(master))
      break if condition
    end
    condition
  end

  def degree_sub_list(permalink, list=[])
    person = get_person(permalink)
    degree_param = (!person.degrees.nil? ? person.degrees['items'] : [])
    degree_param.each do |deg|
      subject ||= deg['degree_subject']
      list << subject
    end
    list.compact
  end

  def degree_type_list(permalink, list=[])
    person = get_person(permalink)
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
      total += nil_addition_guard(get_org(org).total_funding_usd)
    end
    total
  end

  def count_of_product(org_list, total = 0)
    p "count_of_product"
    org_list.each do |org|
      total += nil_addition_guard(get_total_num(get_org(org).products))
    end
    total
  end

  def count_of_news(org_list, total = 0)
    p "count_of_news"
    org_list.each do |org|
      total += nil_addition_guard(get_total_num(get_org(org).news))
    end
    total
  end
 end
end