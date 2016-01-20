module CafeParser
  class NaverCafeParser < ParserUsage

    def self.can_parse?(site)
      true
    end

    def self.create(site)
      NaverParserV1.new()
    end
  end


  class NaverParserV1

    def initialize
      @cafe_list = Cafe.new()
      #dummy
      @cafe_list.name = "specup"
      @cafe_list.current_page = "1"
      @cafe_list.page = "10"
      @cafe_list.url =
          "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=15754634&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
      #
      @mechanize =
          Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
      @mechanize.user_agent_alias = 'Mac Safari'
    end

    def user_id
      view = page.css("td.p-nick a").to_a

      user_id = view.map do |v|
        id = v["onclick"].split(",")
        id[1].gsub!(/[^0-9A-Za-z.\-]/, '')
      end
      puts user_id.uniq
    end

    def user_name
      a = page
      a.encoding = "euc-kr"
      view = a.css("td.p-nick a").to_a

      user_name = view.map do |v|
        id = v["onclick"].split(",")
        id[3].gsub!(/[^0-9A-Za-zㄱ-ㅎㅏ-ㅣ가-힣.\-]/, '')
      end
      user_name.uniq
    end

    def user_id_list
      @cafe_list.each do |list|
        puts list.url
      end
    end

    def page()
      @mechanize.get("#{@cafe_list.url}"+"#{@cafe_list.current_page}")
    end

    def all_posts
      puts page.css("span.p11 strong").text
    end


    def last_page
      @cafe_list.current_page = '2'
    end

    def all_pages
      all_pages_number =  all_post_number / 50
    end

  end
end