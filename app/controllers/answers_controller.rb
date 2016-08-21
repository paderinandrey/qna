class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end  
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end
  
  def best
    @answer = Answer.find(params[:answer_id])
    if current_user.author_of?(@answer.question)
      @answer.switch_best
      @answer.reload
    end  
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
