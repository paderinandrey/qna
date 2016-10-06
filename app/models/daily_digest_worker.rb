class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  
  requrrence { daily(1) }
  
  def perform
    User.send_delay_digest
  end
end
