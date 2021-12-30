class TemperatureConfigsController < ApplicationController
  before_action :set_variables, only: [:edit, :update, :destroy]

  def index
    @configs = TemperatureConfig.all
  end

  def new
    @config = TemperatureConfig.new()
  end

  def create
    @config = TemperatureConfig.new(config_params)
   
    if @config.save
      redirect_to temperature_configs_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end 

  def update
    if @config.update(config_params)
      redirect_to temperature_configs_path
    else
      render :edit, status: :unprocessable_entity
    end 
  end

  def destroy
    @config.delete
    redirect_to temperature_configs_path
  end
   
  private
  def config_params
    params.require(:temperature_config).permit(:key, :min, :max, :description)
  end

  def set_variables
    @config = TemperatureConfig.find(params[:id])
  end
end
