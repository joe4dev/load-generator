class CreateJmeterTasks < ActiveRecord::Migration
  def change
    create_table :jmeter_tasks do |t|
      t.string :test_plan
      t.string :benchmark
      t.string :node
      t.integer :status

      t.timestamps null: false
    end
  end
end
