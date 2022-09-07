class Priority < ApplicationRecord
  has_many :tasks, dependent: :nullify

  validates :name, presence: true
end
