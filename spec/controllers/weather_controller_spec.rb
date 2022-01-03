require 'rails_helper'

RSpec.describe WeatherController, :type => :controller do
  before :each do
    TemperatureConfig.create(key: 'cold', min: -40, max: 10, description: 'Cold range config')
    TemperatureConfig.create(key: 'warm', min: 10, max: 30, description: 'Warm range config')
    TemperatureConfig.create(key: 'hot', min: 30, max: 99, description: 'Hot range config')
  end

  subject { post :get_info, params: params }

  let(:params) {
    {
      zip: "valid-uk_zip"
    }
  }
  let(:response) {
    {
      status: 'success',
      message: 'For the supplied zip code (Evesham, Worcestershire), and based on the existing configurations the weather is cold, 9.3 °C'
    }
  }

  before :each do
    allow_any_instance_of(WeatherInformation).to receive(:retrieve).and_return(response)
  end

  it {is_expected.to have_http_status(302)}
end