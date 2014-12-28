class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string :command
      t.text :params
      t.string :comment
      t.datetime :time

      t.timestamps
    end
  end
end
