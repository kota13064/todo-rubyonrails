class Tag < ApplicationRecord
  has_many :task_tag_relationships, dependent: :destroy
  has_many :tasks, through: :task_tag_relationships, dependent: :nullify

  validates :name, presence: true,
                   uniqueness: true

  scope :search, lambda { |params|
    order(created_at: :desc)
      .search_by_name(params[:name])
  }

  scope :search_by_name, lambda { |name|
    where('tags.name LIKE ?', "%#{sanitize_sql_like(name)}%") if name.present?
  }
end
