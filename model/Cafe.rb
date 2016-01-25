require_relative '../environment'
class Cafe < ActiveRecord::Base
end

d = Cafe.new
d.url = "1"
d.save