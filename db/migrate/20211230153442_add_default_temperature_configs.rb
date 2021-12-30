class AddDefaultTemperatureConfigs < ActiveRecord::Migration[5.2]
  def up
    TemperatureConfig.create(key: 'cold', min: -40, max: 10, description: 'Cold range config')
    TemperatureConfig.create(key: 'warm', min: 10, max: 30, description: 'Warm range config')
    TemperatureConfig.create(key: 'hot', min: 30, max: 99, description: 'Hot range config')
  end

  def down
    TemperatureConfig.where(key: ['cold', 'warm', 'hot']).delete_all
  end
end
