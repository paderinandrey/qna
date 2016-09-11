require 'rails_helper'
require Rails.root.join "spec/models/concerns/votable_spec.rb"

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).touch(true) }
  it { should belong_to :user }
  
  it_behaves_like 'votable'

  it { should validate_presence_of :body }
  
  it { should accept_nested_attributes_for :attachments }
  
  describe ':best' do
    it 'orders by best' do
      last_answer = create(:answer, best: false, created_at: Time.zone.today)
      best_answer = create(:answer, best: true, created_at: Time.zone.tomorrow)
      early_answer = create(:answer, best: false, created_at: Time.zone.yesterday)
  
      results = Answer.all
      
      expect(results).to eq [best_answer, early_answer, last_answer]
    end
  end
  
  describe '#switch_best' do
    it { should respond_to :switch_best }
  
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user, best: false) }
  
    it 'choose the best answer and cancel it' do
      answer.switch_best
      answer.reload
      
      expect(answer.best).to eq true
      
      answer.switch_best
      answer.reload
      
      expect(answer.best).to eq false
    end
  end  
end
