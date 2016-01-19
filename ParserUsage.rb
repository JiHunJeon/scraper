require 'nokogiri'
require 'open-uri'
require 'mechanize'
require_relative 'Cafe'

class ParserUsage
  def initialize()
    @cafe_list = Cafe.new();
    #dummy
    @cafe_list.cafe_name = "specup"
    @cafe_list.cafe_current_page_position = "1"
    @cafe_list.cafe_current_post_position = "2"
    @cafe_list.cafe_url = "http://cafe.naver.com/specup.cafe?iframe_url=/ArticleList.nhn%3Fsearch.boardtype=L%26search.questionTab=A%26search.clubid=15754634%26search.totalCount=151%26search.page="
    #
    @mechanize = Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
    @mechanize.user_agent_alias = 'Mac Safari'


  end

  # save DB after parsing the last post number
  def update_cafe_last_post_number
    page = get()
    puts page.css("span.p11 strong").text
  end

  def get_user_id_list
    page = get()
    puts page.search("td")
  end

  def get
    @mechanize.get("#{@cafe_list.cafe_url}"+"#{@cafe_list.cafe_current_page_position}")
  end
end