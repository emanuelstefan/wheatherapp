class WheatherController < ApplicationController
  attr_reader :error
  before_action :set_variables, only: :index

  def index
  end

  def getweatherinfo

    # call weatherapi with zip param
    
    # if response is 200 set result variable with status success and message
    #   else set variable with status "error" and message

    render :nothing
  end

  private 
  def set_variables
    @result = {
      status: nil,
      message: nil
    }
  end

  def error
    result[:error]
  end
end
