require 'nokogiri'
require 'open-uri'
require 'mechanize'
require_relative 'environment'
require_relative 'ParserUsage'
require_relative 'parsers/NaverCafeParser'




# parser = ParserUsage.new()
#
# parser.get_user_id_list

naver = CafeParser::ParserUsage.parser_for(:naver)
naver.user_id_list
