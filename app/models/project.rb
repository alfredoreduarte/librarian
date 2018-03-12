class Project < ApplicationRecord
	enum project_type: { fb_messenger: 0 }
	validates :title, :project_type, presence: true
	has_many :users
end
