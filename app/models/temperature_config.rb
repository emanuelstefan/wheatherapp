class TemperatureConfig < ActiveRecord::Base
  validates :key, :min, :max, presence: true
  validates :key, uniqueness: true

  validate :proper_range

  def proper_range
    if(min && max) 
      errors.add(:min, 'Range :min value should be lower than :max value.') if min > max    
    else
      return false
    end
  end
end
