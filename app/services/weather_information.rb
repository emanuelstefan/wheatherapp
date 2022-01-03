class WeatherInformation
  PERMITTED_COUNTRIES = ['UK', 'United Kingdom'].freeze

  def initialize(key:, zip:)
    @query = {
      key: key,
      q: zip
    }
  end

  def retrieve
    response = HTTParty.get(
      'https://api.weatherapi.com/v1/current.json',
      query: @query
    )

    case response.code
    when 200
      raise "You have entered a non-UK zipcode. (#{JSON.parse(response.body)['location']['country']})" unless PERMITTED_COUNTRIES.include? JSON.parse(response.body)['location']['country']
      
      process_data(response.body)
    when 401
      raise "#{JSON.parse(response.body)["error"]["message"]}. See README.md for setup details."
    when 400
      raise "#{JSON.parse(response.body)["error"]["message"]}"
    else
      raise "Unknown error while retrieving weather data response"
    end
  end

  def process_data(data)
    response = JSON.parse(data)
    config = TemperatureConfig.where(
      "min < ? AND max >= ?", 
      response['current']['temp_c'], 
      response['current']['temp_c']
    )
    weather_type = config.any? ? config.first.key : 'not coresponding to any existing configuration'
    {
      status: 'success',
      message:  "For the supplied zip code (#{response['location']['name']}, #{response['location']['region']}), and based on the existing configurations the weather is #{weather_type}, #{response['current']['temp_c']} °C"
    }
  end
end
