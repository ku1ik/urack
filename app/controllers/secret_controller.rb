class SecretController < URack::Controller
  def index
    authenticate!
    cookies["jola"] ||= 0
    cookies["jola"] += 1
    render "This is secret!"
  end
end
