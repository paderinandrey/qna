class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include Voted
  
  def index
    @questions = Question.all
  end

  def show
    
    @answer = @question.answers.build
    @answer.attachments.build
    @answers = @question.answers
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages.to_s
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:notice] = 'Your question has been updated successfully.'
        redirect_to @question
      else
        flash[:error] = @question.errors.full_messages
        render :edit
      end
    else
      flash[:error] = 'You cannot edit questions written by others.'
      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question has been successfully deleted!'
      redirect_to questions_path
    else
      flash[:error] = 'You cannot delete questions written by others.'
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
