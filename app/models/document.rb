class Document < ApplicationRecord
  extend Enumerize

  has_many :commands, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :project_gems, dependent: :destroy

  validates :name, :text, presence: true

  accepts_nested_attributes_for :entities, allow_destroy: true
  accepts_nested_attributes_for :project_gems, allow_destroy: true

  enumerize :language, in: %w[English Russian]
end
