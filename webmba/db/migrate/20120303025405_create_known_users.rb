class CreateKnownUsers < ActiveRecord::Migration
  def change
    create_table :known_users do |t|
      t.string :name
      t.string :email
      t.string :mobile

      t.timestamps
    end
  end
end
