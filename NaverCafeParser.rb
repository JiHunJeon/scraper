require_relative 'ParserUsage'
require_relative 'Cafe'

class NaverCafeParser


def user_id

end

def page
  @mechanize.get("#{@cafe_list.cafe_url}"+"#{@cafe_list.cafe_current_page_position}")
end
end