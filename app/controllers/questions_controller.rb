class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action -> { publish_question(params[:action]) }, only: [:create]
  authorize_resource
  
  respond_to :html
  respond_to :json, only: :create
  
  include Voted
  
  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
                             .merge(user: current_user)
  end
  
  def publish_question(action)
    PrivatePub.publish_to("/questions", question: @question.to_json, action: action) if @question.valid?
  end
end
