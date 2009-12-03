require File.join(File.dirname(__FILE__), "config/init.rb")

use Rack::Session::Cookie
use Rack::Flash
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ExceptionsController.action(:unauthenticated)
end

app = URack::App.new

if false
  run Usher::Interface.for(:rack) do
    # get('/jola').to(app)
    get('/').to(lambda { |env| [200, {}, ["Hi mate!"]] })
    # add('/hello/:controller').to(app)
    # add('/').to(app)
    # default ExceptionsController.action(:not_found)
  end
else
  run app
end
