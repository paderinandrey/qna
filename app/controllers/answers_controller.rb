class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  after_action -> { publish_answer(params[:action]) }, only: [:create, :update, :destroy]
  authorize_resource
  
  respond_to :js, :json

  include Voted
  

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end
  
  def best
    @answer.switch_best
    @answer.reload
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
  
  def publish_answer(action)
    PrivatePub.publish_to("/questions/#{ @answer.question_id }/answers", answer: @answer.to_json, action: action) if @answer.valid?
  end
end
