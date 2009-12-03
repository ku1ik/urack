class FrontController < URack::Controller
  def index
    render "Welcome! #{cookies['jola']}"
  end
end
