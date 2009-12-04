require File.join(File.dirname(__FILE__), "config/init.rb")

use Rack::MethodOverride
use Rack::Session::Cookie
use Rack::Flash
use Rack::NestedParams

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ExceptionsController.action(:unauthenticated)
end

usher_app = Usher::Interface.for(:rack) do
  # root
  get('/').to(FrontController.action(:index))
  # index
  get('/:controller(/)').to(lambda { |env| URack::App.new(env['usher.params'], :index).call(env) })
  # show
  get('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::App.new(env['usher.params'], :show).call(env) })
  # new
  get('/:controller/new(/)').to(lambda { |env| URack::App.new(env['usher.params'], :new).call(env) })
  # create
  post('/:controller(/)').to(lambda { |env| URack::App.new(env['usher.params'], :create).call(env) })
  # member action
  get('/:controller/{:id,\d+}/:action(/)').to(lambda { |env| URack::App.new(env['usher.params']).call(env) })
  # update
  put('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::App.new(env['usher.params'], :update).call(env) })
  # destroy
  delete('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::App.new(env['usher.params'], :destroy).call(env) })
  # 404
  default ExceptionsController.action(:not_found)
end

run usher_app
