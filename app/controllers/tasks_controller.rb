class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "更新されました" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :detail)
    end
end
