require 'pry'
require 'nokogiri'
require 'open-uri'

URI_DEPUTIES_LIST = "http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"
CSS_PATH_MAIL = "dd:nth-child(4) > a:nth-child(1)"
CSS_PATH_NAME = "div.titre-bandeau-bleu.clearfix h1"
CSS_PATH_DEPUTIES_URLS = "div#deputes-list li a"

def element_from_css(uri_str, css_select_str)
  Nokogiri::HTML(open(uri_str)).css(css_select_str)
end

def elements_from_css(uri_str, css_select_str)
  collected_elements = []
  Nokogiri::HTML(open(uri_str)).css(css_select_str).each { |node| collected_elements << node }
  return collected_elements
end

def get_deputy_infos(deputy_uri_str)
  email = element_from_css(deputy_uri_str, CSS_PATH_MAIL).text
  name = element_from_css(deputy_uri_str, CSS_PATH_NAME).text.split
  name.delete_at(0)
  firstname = name[0]
  lastname = name[1]
  return infos = { "first_name" => firstname, "last_name" => lastname, "email" => email }
end

def get_deputies_urls(list_uri_str = URI_DEPUTIES_LIST)
  urls = []
  elements_from_css(list_uri_str, CSS_PATH_DEPUTIES_URLS).each do |element| 
    urls << ("http://www2.assemblee-nationale.fr" + element['href'])
  end
  return urls
end

def get_deputies_informations
  list = []
  get_deputies_urls.each do |url|
    list << get_deputy_infos(url)
    puts list[get_deputies_urls.index(url)]
  end
  return list
end

get_deputies_informations