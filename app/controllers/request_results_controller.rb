class RequestResultsController < ApplicationController
  def show
    request_result = BinanceGrabber.call
  end
end
