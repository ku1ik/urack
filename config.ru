require File.join(File.dirname(__FILE__), "config/init.rb")

use Rack::MethodOverride
use Rack::Session::Cookie
use Rack::Flash
use Rack::NestedParams

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ExceptionsController.action(:unauthenticated)
end

app = URack::App.new

usher_app = Usher::Interface.for(:rack) do
  # root
  get('/').to(app)
  
  # index
  get('/:controller(/)').to(app)

  # new
  get('/:controller/new(/)').to(app)
  
  # create
  post('/:controller(/)').to(app)
  
  # edit
  get('/:controller/{:id,\d+}/:action(/)').to(app)
  
  # update
  put('/:controller/{:id,\d+}(/)').to(app)
  
  # destroy
  delete('/:controller/{:id,\d+}(/)').to(app)

  # 404
  default ExceptionsController.action(:not_found)
end

run usher_app
