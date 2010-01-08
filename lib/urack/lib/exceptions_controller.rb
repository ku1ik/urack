module URack
  class ExceptionsController < Controller
    templates_path URack.root + "/app/views/exceptions"
    
    def unauthenticated
      render
    end
    
    def not_found
      render "404 homie :("
    end
  end
end
