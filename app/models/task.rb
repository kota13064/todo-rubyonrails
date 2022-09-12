class Task < ApplicationRecord
  belongs_to :task_status
  belongs_to :priority

  validates :name, presence: true

  scope :default, lambda {
    select('tasks.*, task_statuses.name AS status_name, priorities.name AS priority_name')
      .joins(:task_status)
      .joins(:priority)
      .order(created_at: :desc)
  }

  def self.search(search_params)
    @tasks = default
    @tasks = @tasks.where('tasks.name LIKE ?', "%#{Task.sanitize_sql_like(search_params[:name])}%") if search_params[:name].present?
    @tasks = @tasks.where(task_status_id: search_params[:task_status_id]) if search_params[:task_status_id].present?

    @tasks = @tasks.reorder(search_params[:order_column] => search_params[:order]) if search_params[:order].present? && search_params[:order_column].present?

    @tasks
  end
end
