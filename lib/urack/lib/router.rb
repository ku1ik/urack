module URack
  class Router
    def initialize(params, action=nil)
      action ||= params[:action]
      name = params[:controller].camel_case + "Controller"
      begin
        controller = Object.const_get(name)
        @action = controller.action(action)
      rescue NameError
      end
    end
    
    def call(env)
      if @action
        @action.call(env)
      else
        URack.exceptions_controller.action(:not_found).call(env)
      end
    end
  end
end
