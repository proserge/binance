require 'openssl'
require "base64"
require 'date'
 
class BinanceGrabber
  def initialize
    time = DateTime.now.strftime('%Q')
    secret = Rails.application.credentials.secret_key
    recv_window = 5000
    signature  = OpenSSL::HMAC.hexdigest('sha256', secret, "recvWindow=#{recv_window}&timestamp=#{time}")
     
    @header = { "X-MBX-APIKEY"  => Rails.application.credentials.api_key }
    @url = "https://api.binance.com/api/v3/account?recvWindow=5000&timestamp=#{time}&signature=#{signature}"
  end
   
  def call
    response = HTTParty.get(@url, headers: @header)
     
    http_code =response.code
    parsed_response = response.parsed_response
     
    if parsed_response.has_key?("code")
      @error_message = "Got an error from API: error code is #{parsed_response['code']}, error message is #{parsed_response['msg']}"
    end
    case http_code
    when 200
      @status_message = "#{http_code} OK"
      @new_record = RequestResult.new(raw_data: parsed_response)
      @last_record = RequestResult.last 
      if @last_record == nil || @last_record["updateTime"].to_i < @new_record["updateTime"].to_i
        if @new_record.save
          puts 'Record is added'
        else
          puts 'The error was occured while saving to database!'
        end
      end
    when 401
      @status_message = "#{http_code} Unauthorized request"
    when 418
      @status_message = "#{http_code} IP has been auto-banned for continuing to send requests after receiving 429 codes!"
    when 429
      @status_message = "#{http_code} Request rate limit exceeded!"
    when 400...499
      @status_message = "#{http_code} Malformed request"
    when 500..599
      @status_message = "#{http_code} Binance internal error"
    end
  end
end