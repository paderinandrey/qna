require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).touch(true) }
  it { should belong_to :user }
  it { should have_many(:comments).dependent(:destroy) }
  
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
  
    it 'choose the best answer' do
      answer.switch_best
      answer.reload
      
      expect(answer.best).to eq true
    end
    
    it 'cancel best answer' do
      answer.update(best: true)
      answer.switch_best
      answer.reload
      
      expect(answer.best).to eq false
    end
  end  
  
  describe '#notify_subscribers' do
    let(:answer) { build(:answer) }
    
    it 'notify subscribers by email' do
      expect(answer).to receive(:notify_subscribers).and_call_original
      answer.save
    end
  end
end
