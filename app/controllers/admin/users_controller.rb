module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :admin_user
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.search(search_params)
    end

    def show
      @user = User.default.find(params[:id])
      tasks_search_params[:per] = 10 if tasks_search_params[:per].present?
      @tasks = Task.search(tasks_search_params).select_user(@user.id)
    end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_user_url(@user), notice: I18n.t('notice.create')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_url(@user), notice: I18n.t('notice.update')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_url, notice: I18n.t('notice.destroy')
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end

    def admin_user
      redirect_to root_path unless current_user.is_admin?
    end

    def search_params
      params.permit(:page, :per)
    end

    def tasks_search_params
      params.permit(:name, :task_status_id, :order_column, :order, :page, :per)
    end
  end
end
