require 'nokogiri'
require 'open-uri'
require 'mechanize'
require_relative 'Cafe'
require_relative 'ParserUsage'

parser = ParserUsage.new()


parser.update_cafe_last_post_number
parser.get_user_id_list




# cafe_list = Cafe.new()
#
# cafe_list.cafe_name = "specup"
# cafe_list.cafe_url = "specup"
#
# user_agent = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
#
# page = Nokogiri::HTML(open("http://cafe.naver.com/#{cafe_list.cafe_url()}","User-Agent" => user_agent).read.encode('utf-8','euc-kr'))
#
# puts page.css("span.p11 strong").text


