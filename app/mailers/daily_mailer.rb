class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.from_yesterday

    mail to: user.email, subject: 'Новые вопросы для Вас!'
  end
end
