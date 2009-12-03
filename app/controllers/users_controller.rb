class UsersController < URack::Controller
  def index
    @users = %w(jola misio siekacz)
    render
  end
  
  def edit
    render "edit ;)"
  end
end
