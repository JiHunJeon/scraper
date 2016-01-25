require '../environment'

class User < ActiveRecord::Base
end


t = User.new
t.name ="name"
t.user_id = "id"

t.save