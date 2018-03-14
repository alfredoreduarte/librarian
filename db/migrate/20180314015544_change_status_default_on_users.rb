class ChangeStatusDefaultOnUsers < ActiveRecord::Migration[5.1]
  def change
  	change_column_default(:users, :status, 0)
  end
end
