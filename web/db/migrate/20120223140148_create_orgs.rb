class CreateOrgs < ActiveRecord::Migration
  def change
    create_table :orgs do |t|
      t.string :name
      t.integer :org_type_id
      t.string :org_type_name
      t.integer :school_id
      t.string :school_name
      t.integer :events
      t.integer :followed
      t.integer :joined
      t.string :chairman
      
      t.timestamps
    end
  end
end
