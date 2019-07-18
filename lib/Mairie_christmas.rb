require 'pry'
require 'nokogiri'
require 'open-uri'

URI_TOWNHALLS_LIST = "https://www.annuaire-des-mairies.com/val-d-oise.html"
CSS_PATH_EMAIL = "table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)"
CSS_PATH_TOWNHALL_URLS = "tr td p a.lientxt"

def element_from_css(uri_str, css_select_str)
  Nokogiri::HTML(open(uri_str)).css(css_select_str)
end

def elements_from_css(uri_str, css_select_str)
  collected_elements = []
  Nokogiri::HTML(open(uri_str)).css(css_select_str).each { |node| collected_elements << node }
  return collected_elements
end

def get_townhall_email(townhall_uri_str)
  element_from_css(townhall_uri_str, CSS_PATH_EMAIL).text
end

def get_townhall_urls(list_uri_str = URI_TOWNHALLS_LIST)
  urls = []
  elements_from_css(list_uri_str, CSS_PATH_TOWNHALL_URLS).each do |element| 
    urls << ("https://www.annuaire-des-mairies.com/" + element['href'].delete_prefix("./"))
  end
  return urls
end

def get_townhall_names(list_uri_str = URI_TOWNHALLS_LIST)
  names = []
  elements_from_css(list_uri_str, CSS_PATH_TOWNHALL_URLS).each do |element| 
    names << element.text
  end
  return names
end

def get_townhall_emails_list
  names = get_townhall_names
  urls = get_townhall_urls
  list = []
  names.each do |city|
    list << { city => get_townhall_email(urls[names.index(city)])}
    puts list[names.index(city)]
  end
  return list
end

get_townhall_emails_list