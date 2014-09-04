class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :command
      t.string :comment

      t.timestamps
    end
  end
end
