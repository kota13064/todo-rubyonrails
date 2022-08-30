class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    if params[:order].present? && params[:order_column].present? then
      @tasks = Task.all.order(params[:order_column] => params[:order])
    else
      @tasks = Task.all.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to task_url(@task), notice: "新規作成されました"
    else
      render :new, status: :unprocessable_entity #HTTP status 422
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: "更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "削除されました"
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render file: 'public/404.html', status: 404, content_type: 'text/html'
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :detail, :deadline, :task_status_id)
    end
end
