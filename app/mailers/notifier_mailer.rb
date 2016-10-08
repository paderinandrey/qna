class NotifierMailer < ApplicationMailer
  def new_answer_added(subscription)
    @question = subscription.question

    mail to: subscription.user.email, subject: 'На Ваш вопрос ответили'
  end
end
