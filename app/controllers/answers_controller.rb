class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  after_action -> { publish_answer(params[:action]) }, only: [:create, :update, :destroy]

  respond_to :js, :json

  include Voted
  
  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    if current_user.author_of?(@answer) 
      @answer.update(answer_params)
      respond_with(@answer)
    else
      flash[:error] = 'You cannot change answers written by others!'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with(@answer.destroy)
    else
      flash[:error] = 'You cannot delete answers written by others!'
    end
  end
  
  def best
    if current_user.author_of?(@answer.question)
      @answer.switch_best
      @answer.reload
    else
      flash[:error] = 'You cannot change answers written by others!'
    end  
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
          .merge(user: current_user)
  end
  
  def publish_answer(action)
    PrivatePub.publish_to("/questions/#{ @answer.question_id }/answers", answer: @answer.to_json, action: action) if @answer.valid?
  end
end
