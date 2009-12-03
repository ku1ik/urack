class SessionController < URack::Controller
  def login
    authenticate!
    flash[:notice] = "Logged in :)"
    redirect_back_or "/", :ignore => ["/login"]
  end
  
  def logout
    # flash[:notice] = "Logged out :("
    logout!
    redirect_back_or "/"
  end
end
