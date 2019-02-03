class RequestResultsController < ApplicationController
  
  def binance_grab
    BinanceGrabber.new.call
  end

  def binance_parse
    BinanceParser.new.call
  end

end
