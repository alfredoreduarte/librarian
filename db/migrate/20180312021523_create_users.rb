class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :token
      t.string :email
      t.string :phone
      t.string :timezone
      t.string :ip_address
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
