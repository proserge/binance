require 'rufus-scheduler'

job = Rufus::Scheduler.singleton

job.every '1h' do
  BinanceGrabber.new.call
  BinanceParser.new.call
end