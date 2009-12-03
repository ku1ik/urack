puts "Loading gems..."
require File.join(File.dirname(__FILE__), "../vendor/gems/environment")
Bundler.require_env

app_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# load lib/rackr
puts "Loading racker libs..."
Dir[app_root + "/lib/urack/*.rb"].each { |f| require f }

URack.root = app_root

# load models
puts "Loading models..."
Dir[URack.root + "/app/models/*.rb"].each { |f| require f }

# load controllers
puts "Loading controllers..."
Dir[URack.root + "/app/controllers/*.rb"].each { |f| require f }
