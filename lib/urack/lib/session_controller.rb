module URack
  class SessionController < Controller
    def login
      authenticate!
      flash[:notice] = "Logged in :)"
      redirect_back_or "/", :ignore => ["/login"]
    end
    
    def logout
      logout!
      flash[:notice] = "Logged out :("
      redirect_back_or "/"
    end
  end
end
