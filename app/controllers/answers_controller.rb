class AnswersController < ApplicationController
  before_action :authenticate_user!
  #before_action :find_question

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = "Your answer successfully created."
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
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = "Your answer has been successfully deleted!"
    else
      flash[:error] = "You cannot delete answers written by others."
    end
    redirect_to  @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
