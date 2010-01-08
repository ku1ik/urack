module URack
  class << self
    attr_accessor :root
    attr_accessor :router
    attr_accessor :root_endpoint
    attr_accessor :exceptions_controller
    attr_accessor :session_controller
    # attr_accessor :rackup_binding
  end

  class Bootloader
    def self.run(b)
      Bundler.require_env
      # load URack libs
      %w(controller coreext router warden session_controller exceptions_controller).each { |f| require File.dirname(__FILE__) + "/lib/#{f}" }
      # load middlewares
      eval File.read(File.join(File.dirname(__FILE__), "lib/middlewares.rb")), b
      # load controllers
      Dir[URack.root + "/app/controllers/*.rb"].each { |f| require f }
      # set default endpoints
      URack.session_controller = SessionController
      URack.exceptions_controller = ExceptionsController
      URack.root_endpoint = lambda { Rack::Response.new("WLKM!", 200).finish }
      # load config/init.rb
      require File.join(URack.root + "/config/init.rb")
      # setup router
      setup_router
    end
    
    def self.setup_router
      # Set up /, /login, /logout and RESTful routes for resources
      URack.router = Usher::Interface.for(:rack) do
        # root
        get('/').to(URack.root_endpoint).name(:root)
        # index
        get('/:controller(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :index).call(env) })
        # show
        get('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :show).call(env) })
        # new
        get('/:controller/new(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :new).call(env) })
        # create
        post('/:controller(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :create).call(env) })
        # member action
        get('/:controller/{:id,\d+}/:action(/)').to(lambda { |env| URack::Router.new(env['usher.params']).call(env) })
        # update
        put('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :update).call(env) })
        # destroy
        delete('/:controller/{:id,\d+}(/)').to(lambda { |env| URack::Router.new(env['usher.params'], :destroy).call(env) })
        # login
        add('/login').to(URack.session_controller.action(:login)).name(:login)
        # logout
        get('/logout').to(URack.session_controller.action(:logout)).name(:logout)
        # 404
        default URack.exceptions_controller.action(:not_found)
      end
    end
  end
end

# URack.rackup_binding = self.send(:binding)
