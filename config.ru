require File.join(File.dirname(__FILE__), "config/init.rb")

use Rack::Session::Cookie
use Rack::Flash
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ExceptionsController.action(:unauthenticated)
end

app = URack::App.new
run app

# run Usher::Interface.for(:rack) do
  # get('/jola').to(app)
  # add('/hello/:controller').to(app)
  # default FrontController.new
  # add('/').to(app)
# end
