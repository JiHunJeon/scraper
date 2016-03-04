# require 'mechanize'
#
# a = Mechanize.new {|a| a.ssl_version, a.verify_mode ='TLSv1',OpenSSL::SSL::VERIFY_NONE}
# a.user_agent_alias = 'Mac Safari'
# a.set_proxy '192.99.54.41','3128'
#
# page = nil
# 1.times do |i|
#   a.cookie_jar.clear!
#   a.get('http://www.naver.com/')
#   a.get('https://search.naver.com/search.naver?where=post&sm=tab_jum&ie=utf8&query=%EB%A0%88%EB%AA%AC%EC%B2%AD')
#   #page = a.get('http://blog.naver.com/PostView.nhn?blogId=gaver1213&logNo=220361651785&beginTime=0&jumpingVid=&from=search&redirect=Log&widgetTypeCall=true&topReferer=http://search.naver.com/search.naver?where=post&sm=tab_jum&ie=utf8&query=레몬청&url=http://blog.naver.com/gaver1213?Redirect=Log&logNo=220361651785')
#   page = a.get('http://blog.naver.com/gaver1213/220361651785')
#   if i%5 == 0
#   sleep(1)
#   puts i
#   end
# end
# puts page.content

# abc = nil
#
# agent = Mechanize.new
# agent ||= TorPrivoxy::Agent.new '127.0.0.1', '', {8118 => 9050} do |agent|
#   abc = agent.ip
#   puts "New IP is #{agent.ip}"
# end
#
# pp agent.get("http://www.toogeter.com")

# class SongList
#   def search(field,params)
#       puts params[:genre]
#       puts params[:duration]
#   end
# end
#
# list = SongList.new
# list.search(:title,genre:"jazz",duration:270)


rate_mutex = Mutex.new

Thread.new do
  rate_mutex.lock
  loop do
    rate_mutex.sleep 5
    sleep 5
    print "졸라어렵네\n"
  end
end

loop do
  print "Enter currency code and amout:"
  line = gets
  if rate_mutex.try_lock
    puts "#{line}"
    rate_mutex.unlock
  else
    puts "fffff"
  end
end
