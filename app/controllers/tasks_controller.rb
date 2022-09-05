class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks =
      if search_params[:order].present? && search_params[:order_column].present?
        Task.all.order(search_params[:order_column] => search_params[:order])
      else
        Task.all.order(created_at: :desc)
      end

    @tasks = @tasks.where('name LIKE ?', "%#{Task.sanitize_sql_like(search_params[:name])}%") if search_params[:name].present?
    @tasks = @tasks.where(task_status_id: search_params[:task_status_id]) if search_params[:task_status_id].present?
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to task_url(@task), notice: '新規作成されました'
    else
      render :new, status: :unprocessable_entity # HTTP status 422
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: '更新されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: '削除されました'
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render404
    render file: 'public/404.html', status: :not_found, content_type: 'text/html'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :detail, :deadline, :task_status_id)
  end

  def search_params
    params.permit(:name, :task_status_id, :order_column, :order)
  end
end
