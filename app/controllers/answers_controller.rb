class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:create, :destroy]
  
  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      flash[:success] = "Ответ успешно создан"
      redirect_to @question
    else
      flash[:error] = @answer.errors.full_messages
      @answers = @question.answers.reload
      render 'questions/show'
    end
  end
  
  def update
  end
  
  def destroy
    @answer.destroy
    flash[:success] = "Ответ удален"
    redirect_to question_path(@question)
  end
  
  private
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end  
end
