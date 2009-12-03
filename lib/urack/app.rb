module URack
  class << self
    attr_accessor :root
  end
  
  class App
    def call(env)
      p params = env['usher.params']
      # if env['PATH_INFO'] == '/'
      name = "#{params[:controller]}_controller".camel_case
      controller = eval("#{name}")
      controller.action(params[:action] || :index).call(env)
      # elsif env['PATH_INFO'] == '/logout'
      #   SessionController.action(:logout).call(env)
      # elsif env['PATH_INFO'] == '/login'
      #   SessionController.action(:login).call(env)
      # elsif env['PATH_INFO'] =~ /^\/users/
      #   UsersController.action(:index).call(env)
      # elsif env['PATH_INFO'] =~ /^\/secret/
      #   SecretController.action(:index).call(env)
      # else
      #   ExceptionsController.action(:not_found).call(env)
      # end
    end
  end
end
