class NotifierJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Subscription.for_question(answer.question_id).find_each do |subscription|
      NotifierMailer.new_answer_added(subscription).deliver_later
    end
  end
end
