class Cafe
  attr_accessor :cafe_name,:cafe_url,:cafe_current_post_position, :cafe_current_page_position
  attr_reader :cafe_last_post
  def initialize()
    @cafe_name = nil
    @cafe_url = nil
    @cafe_last_post = nil
    @cafe_parsing_last_date = nil
    @cafe_current_post_position = nil
    @cafe_current_page_position = nil
  end

  # def cafe_parsing_last_date_update ()
  #   @cafe_parsing_last_date
  # end

  def calc_all_pages(post_count)
    page_count = @cafe_last_post/16
  end

end