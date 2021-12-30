class CreateTemperatureConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :temperature_configs do |t|
      t.string :key, null: false
      t.integer :min, :limit => 1, null: false
      t.integer :max, :limit => 1, null: false
      t.text :description

      t.timestamps
    end
  end
end
