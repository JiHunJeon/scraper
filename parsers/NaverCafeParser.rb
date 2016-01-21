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

    def initialize
      @list = Array.new()

      @cafe_list = Cafe.new()
      #dummy
      @cafe_list.name = "specup"
      @cafe_list.current_page = 1
      @cafe_list.page = 2
      @cafe_list.url =
          "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=15754634&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
      #
      @list.push(@cafe_list)

      # @cafe_list = Cafe.new()
      # #dummy
      # @cafe_list.name = "openuniversity"
      # @cafe_list.current_page = 1
      # @cafe_list.page = 2
      # @cafe_list.url =
      #     "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=23161524&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
      # #
      # @list.push(@cafe_list)
      @mechanize =
          Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
      @mechanize.user_agent_alias = 'Mac Safari'
    end

    def user_name_list
      name_list = Array.new()
      @list.each do |list|
        name_list =  get_list(list,:user_name)
      end
      name_list.uniq
    end

    def user_name(url,current_page)
      a = page(url,current_page)
      a.encoding = "euc-kr"
      view = a.css("td.p-nick a").to_a

      user_name = view.map do |v|
        id = v["onclick"].split(",")
        id[3].gsub!(/[^0-9A-Za-zㄱ-ㅎㅏ-ㅣ가-힣.\-]/, '')
      end
      user_name.uniq
    end

    def user_id_list
      id_list = Array.new()
      @list.each do |list|
        id_list =  get_list(list,:user_id)
      end
      id_list.uniq
    end

    def user_id(url,current_page)
      view = page(url,current_page).css("td.p-nick a").to_a

      user_id = view.map do |v|
        id = v["onclick"].split(",")
        id[1].gsub!(/[^0-9A-Za-z.\-]/, '')
      end
      user_id.uniq
    end

    # to sleep during 1second after get list.
    def get_list(list,type)
      # puts list.name
      # puts list.url
      tmp_list = Array.new()
      while list.current_page <= list.page
        if list.current_page%10 != 0
          # puts list.current_page
          if NaverParserV1.new.respond_to?(type)
            list_info = [list.url,list.current_page]
            tmp_list.push(NaverParserV1.new.send(type, *list_info))
          else
            puts "dosen't exit method"
            break
          end
          list.current_page += 1
        else
          sleep 1
        end
      end
      tmp_list.uniq
    end

    def page(url,current_page)
      @mechanize.get("#{url}"+"#{current_page}")
    end
  end
end
