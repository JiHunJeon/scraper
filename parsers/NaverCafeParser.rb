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
    SLEEPPAGES = 10 # sleep할 페이지 수
    PAGES = 1000
    LIMITPAGES = 0

    def initialize
      @list = Cafe.all
      @mechanize =
          Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
      @mechanize.user_agent_alias = 'Mac Safari'
    end

    def user_name_list
      name_list = Array.new()
      @list.each do |list|
        name_list.concat(get_list(list,:user_name)).uniq
      end
    end

    def user_id_list
      id_list = Array.new()
      @list.each do |list|
        update_list = update_cafe_info(list)
        if update_list.page <= update_list.last_page
          next
        else
         id_list.concat(get_list(update_list,:user_id)).uniq
        end
      end

    end

    # to sleep during 1second after get list.
    def get_list(list,type)
      tmp_list = Array.new()

      limit_pages |= 0
      if list.page < PAGES
        limit_pages = list.page
      else
        limit_pages = PAGES
      end
      while list.last_page <= limit_pages
        if list.last_page%SLEEPPAGES == 0
          insert_user_id(tmp_list)
          tmp_list.clear
          wait
        else
        end

        if NaverParserV1.new.respond_to?(type)
          list_info = [list.board_url,list.last_page]
          tmp_list.concat(NaverParserV1.new.send(type, *list_info)).uniq
          puts "cafe name: #{list.name}"
          puts "current page: #{list.last_page}"
          puts "parsing data number : #{tmp_list.count}"
          puts "========================================="
        else
          puts "dosen't exit method"
          break
        end
        list.last_page += 1
      end

      cafe = Cafe.find_by(name: list.name)
      cafe.update(last_page: list.last_page,last_scrap: Time.now)
      tmp_list
    end

    # wait a seconds and puts msg
    def wait
      puts "wait a 2 seconds"
      sleep(2)
    end

    def insert_user_id(list)
      puts "insert user id in the table"
      list.uniq.each_with_index do |t,index|
        User.create(platform: "naver", user_id: t)
        print index
      end
    end

    def user_name(board_url,current_page)
      raw = scrap(board_url,current_page)
      raw.encoding = "euc-kr"
      extraction = raw.css("td.p-nick a").to_a

      user_name = extraction.map do |v|
        id = v["onclick"].split(",")
        id[3].gsub!(/[^0-9A-Za-zㄱ-ㅎㅏ-ㅣ가-힣.\-]/, '')
      end
      user_name.uniq
    end

    def user_id(board_url,current_page)
      extraction = scrap(board_url,current_page).css("td.p-nick a").to_a

      user_id = extraction.map do |v|
        id = v["onclick"].split(",")
        id[1].gsub!(/[^0-9A-Za-z.\-]/, '')
      end
      user_id.uniq
    end

    def scrap(url,current_page = nil)
      @mechanize.get("#{url}"+"#{current_page}")
    end

    # save DB before parsing the last post number
    def get_post(url)
      scrap(url).search("span.p11 strong").text.delete(',').to_i
    end

    def get_page(post)
      post / 50
    end

    def get_club_id(url)
      extraction = scrap(url).css("script").to_a
      parse = extraction[0].to_s.split(";")
      /\d+/.match(parse[3])
    end

    def update_cafe_info(cafe)
      update_cafe = Cafe.find_by(name: cafe.name)
      param |= nil
      wait
      if !update_cafe.board_url
        param = insert_addition_cafe_info(cafe)
        puts "cafe name:#{cafe.name}" + param
      else
        param =  update_addition_cafe_info(cafe)
        puts "cafe name:#{cafe.name}" + param
      end
      query = "update caves set #{param} where name = '#{cafe.name}'"
      results = Cafe.connection.execute(query)

     return  Cafe.find_by(name: cafe.name)
    end

    def update_addition_cafe_info(cafe)
      post = get_post(cafe.url)
      page = get_page(post)

      return  "post= '#{post}', page= '#{page}'"
    end

    def insert_addition_cafe_info(cafe)
      post = get_post(cafe.url)
      page = get_page(post)
      club_id = get_club_id(cafe.url)
      board_url = get_board_url(club_id)
      return  "post= '#{post}', page= '#{page}', club_id= '#{club_id}', board_url= '#{board_url}'"
    end

    def get_board_url(club_id)
      "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=#{club_id}&search.totalCount=151&userDisplay=50&noticeHidden=true&search.page="
    end
  end
end
