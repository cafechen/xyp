class CreateUserOrgs < ActiveRecord::Migration
  def change
    create_table :user_orgs do |t|
      t.integer :user_id
      t.integer :org_id
      t.integer :role_id

      t.timestamps
    end
  end
end
