# setup rack endpoints
URack.root_endpoint = FrontController.action(:index)

# load models
puts "Loading models..."
Dir[URack.root + "/app/models/*.rb"].each { |f| require f }
