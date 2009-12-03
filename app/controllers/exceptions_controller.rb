class ExceptionsController < URack::Controller
  def unauthenticated
    render
  end
  
  def not_found
    render "404 homie :("
  end
end
