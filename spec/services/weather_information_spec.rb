require 'rails_helper'

RSpec.describe WeatherInformation do
  before :each do
    TemperatureConfig.create(key: 'cold', min: -40, max: 10, description: 'Cold range config')
    TemperatureConfig.create(key: 'warm', min: 10, max: 30, description: 'Warm range config')
    TemperatureConfig.create(key: 'hot', min: 30, max: 99, description: 'Hot range config')
  end

  let(:api_key) { 'api_key' }
  let(:zip) { 'WR11' }
  let(:weather_response) { 
    OpenStruct.new(
      {
        code: code,
        body: body,
      }
    )
  }

  subject { 
    WeatherInformation.new(
      key: api_key,
      zip: zip
    )
  }

  before :each do
    allow(HTTParty).to receive(:get).and_return(weather_response)
  end

  context '200 response code' do
    let(:code) { 200 }
    let(:body) { 
      {
        location: {
          country: 'UK',
          name: "Evesham",
          region: "Worcestershire"
        },
        current: {
          temp_c: '5'
        }
      }.to_json
    }

    it 'returns corresponding message, stating the weather type (cold) based on existing configurations' do
      response = subject.retrieve
      expect(response).to eq(
        {
          status: "success",
          message: "For the supplied zip code (Evesham, Worcestershire), and based on the existing configurations the weather is cold, 5 °C"
        }
      )
    end

    context 'temperature outside of defined ranges' do
      let(:body) { 
        {
          location: {
            country: 'UK',
            name: "Evesham",
            region: "Worcestershire"
          },
          current: {
            temp_c: '120'
          }
        }.to_json
      }
  
      it 'returns corresponding message, stating the weather type (unknown) based on existing configurations' do
        response = subject.retrieve
        expect(response).to eq(
          {
            status: "success",
            message: "For the supplied zip code (Evesham, Worcestershire), and based on the existing configurations the weather is not coresponding to any existing configuration, 120 °C"
          }
        )
      end
    end

    context 'non UK zip code' do
      let(:code) { 200 }
      let(:body) { 
        {
          location: {
            country: 'USA',
            name: "New York",
            region: "New York"
          },
          current: {
            temp_c: '15'
          }
        }.to_json
      }

      it { expect{subject.retrieve}.to raise_error(RuntimeError, "You have entered a non-UK zipcode. (USA)")}
    end
  end

  context '401 unauthorized code' do
    let(:code) { 401 }
    let(:body) { 
      {
        error: {
          message: 'Invalid API Key'
        }
      }.to_json
    }

    it { expect{subject.retrieve}.to raise_error(RuntimeError, "Invalid API Key. See README.md for setup details.")}
  end

  context '400 bad request' do
    let(:code) { 400 }
    let(:body) { 
      {
        error: {
          message: 'Bad request'
        }
      }.to_json
    }

    it { expect{subject.retrieve}.to raise_error(RuntimeError, 'Bad request')}
  end

  context 'any other status code' do
    let(:code) { 418 }
    let(:body) { }

    it { expect{subject.retrieve}.to raise_error(RuntimeError, 'Unknown error while retrieving weather data response')}
  end
end