module CafeParser
  class NaverCafeParser < ParserUsage
    attr_accessor :list

    def self.can_parse?(site)
      true
    end

    def self.create(site)
      NaverParserV1.new()
    end
  end


  class NaverParserV1
    SLEEPPAGES = 10 # sleep할 페이지 수

    def initialize
      @list = Array.new()

      @cafe_list = Cafe.new()
      #dummy
      @cafe_list.name = "specup"
      @cafe_list.current_page = 1
      @cafe_list.page = 15
      @cafe_list.url =
          "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=15754634&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
      #
      @list.push(@cafe_list)

      @cafe_list = Cafe.new()
      #dummy
      @cafe_list.name = "openuniversity"
      @cafe_list.current_page = 1
      @cafe_list.page = 2
      @cafe_list.url =
          "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=23161524&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
      #
      @list.push(@cafe_list)
      @mechanize =
          Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
      @mechanize.user_agent_alias = 'Mac Safari'
    end

    def user_name_list
      name_list = Array.new()
      @list.each do |list|
        calc_last_page(list.url,list.current_page)
        name_list.concat(get_list(list,:user_name)).uniq
      end
      name_list
    end

    def user_id_list
      id_list = Array.new()
      @list.each do |list|
        id_list.concat(get_list(list,:user_id)).uniq
      end
      id_list
    end

    # to sleep during 1second after get list.
    def get_list(list,type)
      tmp_list = Array.new()
      puts list.name
      puts list.url

      while list.current_page <= list.page
        wait if list.current_page%SLEEPPAGES == 0
        puts list.current_page
        if NaverParserV1.new.respond_to?(type)
          list_info = [list.url,list.current_page]
          tmp_list.concat(NaverParserV1.new.send(type, *list_info)).uniq
          puts tmp_list.count
          puts "========================================="
        else
          puts "dosen't exit method"
          break
        end
        list.current_page += 1
      end
      tmp_list
    end

    # wait a seconds and puts msg
    def wait
      puts "wait a 5 seconds"
      sleep(5)
    end

    def user_name(url,current_page)
      raw = page(url,current_page)
      raw.encoding = "euc-kr"
      extraction = raw.css("td.p-nick a").to_a

      user_name = extraction.map do |v|
        id = v["onclick"].split(",")
        id[3].gsub!(/[^0-9A-Za-zㄱ-ㅎㅏ-ㅣ가-힣.\-]/, '')
      end
      user_name.uniq
    end

    def user_id(url,current_page)
      extraction = page(url,current_page).css("td.p-nick a").to_a

      user_id = extraction.map do |v|
        id = v["onclick"].split(",")
        id[1].gsub!(/[^0-9A-Za-z.\-]/, '')
      end
      user_id.uniq
    end

    def page(url,current_page)
      @mechanize.get("#{url}"+"#{current_page}")
    end
    # save DB before parsing the last post number
    def get_post(url,current_page)
      page(url,current_page).css.text
    end

    def calc_last_page(url,current_page)
      post = get_post(url,current_page)
      page = post/50

      cafe = Cafe.create(url:url,post:post,page:page)
    end
  end
end
