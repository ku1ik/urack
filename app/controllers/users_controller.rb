class UsersController < URack::Controller
  def index
    @users = %w(jola misio siekacz)
    render
  end
end
