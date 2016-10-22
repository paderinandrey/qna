require "rails_helper"

RSpec.describe NotifierMailer, type: :mailer do
  describe "notifier" do
    let(:subscription) { create(:subscription) }
    let(:mail) { NotifierMailer.new_answer_added(subscription).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("На Ваш вопрос ответили")
      expect(mail.to).to eq([subscription.question.user.email])
      expect(mail.from).to eq(["admin@qna.com"])
    end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match(question.title)
    # end
  end
end
