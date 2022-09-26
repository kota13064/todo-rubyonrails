class Tag < ApplicationRecord
  has_many :task_tag_relationships, dependent: :destroy
  has_many :tasks, through: :task_tag_relationships, dependent: :nullify

  validates :name, presence: true
end
