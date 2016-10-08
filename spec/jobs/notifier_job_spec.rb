require 'rails_helper'

RSpec.describe NotifierJob, type: :job do
  let(:question) { create(:question) }
  let!(:new_answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }
  
  it 'Sends notification emails to subscribers ' do
    new_answer.question.subscriptions.each do |subscription|
      expect(NotifierMailer).to receive(:new_answer_added).with(subscription).and_call_original
    end
    NotifierJob.perform_now(new_answer)
  end
end
