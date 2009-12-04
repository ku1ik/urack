module URack
  class << self
    attr_accessor :root
  end
  
  class App
    def initialize(params, action=nil)
      action ||= params[:action]
      name = params[:controller].camel_case + "Controller"
      controller = eval("#{name}")
      @action = controller.action(action)
    end
    
    def call(env)
      @action.call(env)
    end
  end
end
