class Article < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :users
end
