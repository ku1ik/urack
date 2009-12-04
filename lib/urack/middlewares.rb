use Rack::MethodOverride
use Rack::Session::Cookie
use Rack::Flash
use Rack::NestedParams
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ExceptionsController.action(:unauthenticated)
end