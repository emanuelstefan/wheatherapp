class WeatherController < ApplicationController
  def index
  end

  def get_info
    @response = WeatherInformation.new(
      key: "ad0dd95b38184198a10141718213012",
      zip: weather_params[:zip]
    ).retrieve

    respond_to do |format|
      format.html { redirect_to weather_index_path }
      format.js
    end
  rescue StandardError => e
    @response = {
      status: 'error',
      message: e.message
    }
  end

  private
  def weather_params
    params.permit(:zip)
  end
end
