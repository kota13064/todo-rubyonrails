class Task < ApplicationRecord
  belongs_to :task_status

  validates :name, presence: true
end
