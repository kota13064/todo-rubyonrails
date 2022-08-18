class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update ]
  
  def index
    @tasks = Task.all
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

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :detail)
    end
end
