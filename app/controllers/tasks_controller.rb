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

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "新規作成されました" }
      else
        format.html { render :new, status: :unprocessable_entity } #HTTP status 422
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "更新されました" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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
