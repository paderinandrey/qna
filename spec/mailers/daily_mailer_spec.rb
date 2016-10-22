require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:question) { create(:yesterday_question) }
    let(:mail) { DailyMailer.digest(user).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Новые вопросы для Вас!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["admin@qna.com"])
    end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match(question.title)
    # end
  end

end
