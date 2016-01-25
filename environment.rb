require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :host => "121.88.250.82",
    :database => "scrap",
    :username => "zipbac",
    :password => "relifer2015"
)


