class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html  welcome.html
      format.json { render json: @application }
    end
  end
end
