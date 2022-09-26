class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.search(search_params).select_user(current_user.id)
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id

    if @task.save
      redirect_to task_url(@task), notice: I18n.t('notice.create')
    else
      render :new, status: :unprocessable_entity # HTTP status 422
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: I18n.t('notice.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: I18n.t('notice.destroy')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :detail, :deadline, :task_status_id, :priority_id, tag_ids: [])
  end

  def search_params
    params.permit(:name, :task_status_id, :order_column, :order, :page, :per, tag_ids: [])
  end
end
