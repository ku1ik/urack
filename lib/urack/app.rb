module URack
  class << self
    attr_accessor :root
  end
  
  class App
    def initialize(opts={})
      @opts = opts
      @router = Usher::Interface.for(:rack) do
        # root
        get('/').to(opts[:root_app])
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
        # 404
        default opts[:not_found_app]
      end
    end
    
    def call(env)
      @router.call(env)
    end
  end
end
