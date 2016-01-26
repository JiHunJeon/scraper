require 'nokogiri'
require 'open-uri'
require 'mechanize'
require_relative 'model/User'
require_relative 'model/Cafe'
require_relative 'Cafe'


module CafeParser
  class ParserUsage

    def can_parse?(site)
      false
    end

    def create(site)
      nil
    end

    @@parsers = []

    def self.add_parser(p)
      @@parsers << p unless @@parsers.include? p
    end

    def self.parsers
      @@parsers
    end

    def self.parser_for(site)
      @@parsers.each do |parser|
        return parser.create(site) if parser.can_parse?(site)
      end
    end

    def self.load(dirname)
      Dir.open(dirname).each do |fn|
        next unless fn =~ /Parser\.rb$/
        require File.join(dirname,fn)
      end
    end

    def self.inherited(parser)
      self.add_parser(parser)
    end


    # def initialize()
    #
    #   @cafe_list = Cafe.new();
    #   #dummy
    #   @cafe_list.name = "specup"
    #   @cafe_list.current_page = "2"
    #   @cafe_list.current_post = "2"
    #   @cafe_list.url = "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=15754634&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
    #   #
    #   @mechanize = Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
    #   @mechanize.user_agent_alias = 'Mac Safari'
    # end
    #
    # # save DB after parsing the last post number
    # def update_cafe_last_post_number
    #   puts page.css("span.p11 strong").text
    # end
    #
    # def get_user_id_list
    #
    #   page.encoding ='euc-kr'
    #   view = page.css("table tr td.p-nick a").to_a
    #
    #   v2 = Array.new
    #   v2 = view.map do |v|
    #     id = v["onclick"].split(",")
    #     id[1].gsub!(/[^0-9A-Za-z.\-]/,'')
    #   end
    #   puts v2.uniq
    # end
    #
    # def load
    #
    # end
    #
    # def page
    #   @mechanize.get("#{@cafe_list.url}"+"#{@cafe_list.current_page}")
    # end
  end

  ParserUsage.load(File.join(File.dirname(__FILE__),'parsers'))
end