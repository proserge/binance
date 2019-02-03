class BinanceParser
  def initialize
    @raw_data = RequestResult.where("parsed_data IS NULL")
  end
   
  def call
    @raw_data.each do |record|
      #parsed_data[]
      # record['raw_data'] - hash 9
      # record['raw_data']['balances'] - array 160
      balances = []
      record['raw_data']['balances'].each do |item|
        balances << item  if item['free'].to_f != 0.0
      end
      record.update_attributes(parsed_data: balances) #.to_json)
    end
  end
end