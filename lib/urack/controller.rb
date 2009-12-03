require 'uri'

module URack
  class Controller
    
    # class methods
    
    def self.action(name)
      lambda do |env|
        env['x-rack.urack-action'] = name
        self.new.call(env)
      end
    end
    
    def self.name
      to_s.snake_case.gsub('_controller', '')
    end

    # rack endpoint
    
    def call(env)
      @env = env
      action = env['x-rack.urack-action'] or raise RuntimeError.new("No action specified!")
      @response = Rack::Response.new
      @response.write(self.send(action))
      @response.finish
    end
    
    # helpers
    
    def request
      @request ||= Rack::Request.new(@env)
    end
    
    def render(template=nil)
      template = request.env['x-rack.urack-action'] if template.nil?
      layout_path = "#{URack.root}/app/views/layouts/application.html.erb"
      template_path = "#{URack.root}/app/views/#{self.class.name}/#{template}.html.erb"
      Tilt.new(layout_path).render(self) do
        template.is_a?(String) ? template : Tilt.new(template_path).render(self)
      end
    end
    
    def partial(template, opts={})
      template_path = "#{URack.root}/app/views/#{self.class.name}/_#{template}.html.erb"
      locals = { template.to_sym => opts.delete(:with) }.merge!(opts)
      Tilt.new(template_path).render(self, locals)
    end
    
    def status(code)
      @response.status = code
    end
    
    def headers
      @response.header
    end
    alias :header :headers
    
    def redirect_back_or(url, opts={})
      ignore = opts[:ignore]
      if request.referer
        uri = URI(request.referer)
        if (!ignore || !uri.path.in?(ignore))
          url = request.referer
        end
      end
      status 302
      headers["Location"] = url
      "You're being redirected"
    end
    
    def authenticate!
      request.env['warden'].authenticate!
    end
    
    def current_user
      request.env['warden'].user
    end
    
    def logout!(scope=:default)
      request.env['warden'].logout(scope)
    end
    
    def cookies
      request.env['rack.session']
    end
    
    def flash
      request.env['x-rack.flash']
    end
  end
end
