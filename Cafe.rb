class CafeList
  attr_accessor :name,:url,:current_post, :current_page,:page,:board_url
  attr_reader :last_post
  def initialize()
    @name= nil
    @url = nil
    @post =nil
    @page =nil
    @last_post = nil
    @last_date = nil
    @current_post = nil
    @current_page = nil
    @board_url = nil
  end

  # def cafe_parsing_last_date_update ()
  #   @cafe_parsing_last_date
  # end

  def calc_all_pages(post_count)
    page_count = @last_post/16
  end

end