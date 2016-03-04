require 'active_record'
require 'mysql2'
require "mechanize"
require "nokogiri"
require "open-uri"
require "json"

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :host => "121.88.250.82",
    :database => "scrap",
    :username => "zipbac",
    :password => "relifer2015"
)

ActiveRecord::Base.default_timezone = :local

class List < ActiveRecord::Base

end

class Room
  def initialize
    # @room_list = List.all
    @mechanize =
        Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
    @mechanize.user_agent_alias = 'Mac Safari'
    @room_info_api_url = {
        zigbang: {
            doksan: 'https://api.zigbang.com/v2/items?lat_south=37.45335518537516&lat_north=37.482942299091896&lng_west=126.87943097477127&lng_east=126.91931760306952&room=01;02;03;04;05&deposit_s=5000&deposit_e=7000&rent_s=0&rent_e=0',
            gasan: 'https://api.zigbang.com/v2/items?lat_south=37.462068825971514&lat_north=37.49165851263533&lng_west=126.87168556873984&lng_east=126.9115737608987&room=01;02;03;04;05&deposit_s=5000&deposit_e=7000&rent_s=0&rent_e=0'
        },
        dabang: {
            doksan: '',
            gasan: ''
        }
    }
    @room_list_api_url = {
        zigbang: {
            doksan: 'https://api.zigbang.com/v2/items?lat_south=37.45335518537516&lat_north=37.482942299091896&lng_west=126.87943097477127&lng_east=126.91931760306952&room=01;02;03;04;05&deposit_s=5000&deposit_e=7000&rent_s=0&rent_e=0',
            gasan: 'https://api.zigbang.com/v2/items?lat_south=37.462068825971514&lat_north=37.49165851263533&lng_west=126.87168556873984&lng_east=126.9115737608987&room=01;02;03;04;05&deposit_s=5000&deposit_e=7000&rent_s=0&rent_e=0'
        },
        dabang: {
            doksan: '',
            gasan: ''
        }
    }
  end

  def get_room_list
    #방리스트 가져옴
   list =  @mechanize.get(@room_info_api_url[:zigbang][:doksan]).body
  end

  def update_room_list
    #방 리스트 db에 업데이트 시킴
  end

  def generate_zigbang_url()
    #api서버에서 받은 방 id로 request보낼 api서버 주소 생성
  end

  def generate_dabang_url()
    #api서버에서 받은 방 id로 request보낼 api서버 주소 생성
  end
end


test = Room.new()
list = test.get_room_list

result = JSON.parse list

pp result['list_items'][1]