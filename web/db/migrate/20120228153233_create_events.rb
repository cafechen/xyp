class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :place
      t.string :speaker
      t.string :speakerInfo
      t.integer :school_id
      t.string :school_name
      t.integer :org_id
      t.string :org_name
      t.string :sponsor
      t.string :undertaker
      t.string :cooperater
      t.integer :seat
      t.string :brief
      t.integer :status
      t.integer :toward
      t.text :others
      t.datetime :beginTime
      t.datetime :endTime
      t.string :email

      t.timestamps
    end
  end
end
