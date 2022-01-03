class TemperatureConfig < ActiveRecord::Base
  validates :key, :min, :max, presence: true
  validates :key, uniqueness: true

  validates :min, inclusion: { in: -128..127, message: "can only be between -128 and 127" }
  validates :max, inclusion: { in: -128..127, message: "can only be between -128 and 127" }

  validate :proper_range

  def proper_range
    if(min && max) 
      errors.add(:min, 'Range :min value should be lower than :max value.') if min > max    
    else
      return false
    end
  end
end
