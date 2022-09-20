class UserSessionsController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to tasks_path
    else
      flash.now[:danger] = 'メールアドレスかパスワードが間違っています。'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
