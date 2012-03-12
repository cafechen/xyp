class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :mobile
      t.integer :workstate
      t.integer :school_id
      t.string :school
      t.integer :company_id
      t.string :company
      t.integer :title_id
      t.string :title
      t.string :portrait
      t.text :intro
      t.timestamps
    end
  end
end
