class DestroyArticlesUsers < ActiveRecord::Migration[5.1]
  def change
  	drop_table :articles_users
  end
end
