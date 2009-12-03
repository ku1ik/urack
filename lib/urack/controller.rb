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
      body = self.send(action)
      [@status || 200, { "Content-type" => "text/html" }.merge!(headers), [body]]
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
    
    def status(code)
      @status = code
    end
    
    def headers
      @headers ||= {}
    end
    
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
    
    def logout!
      request.env['warden'].logout
    end
    
    def cookies
      request.env['rack.session']
    end
    
    def flash
      request.env['x-rack.flash']
    end
  end
end
