module UserSessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def log_out
    session.delete(:user_id)
    remove_instance_variable(:@current_user)
  end
end
