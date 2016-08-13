class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
  end
  
  def show
    @answer = @question.answers.build
    @answers = @question.answers
  end
  
  def new
    @question = Question.new
  end
  
  def edit
  end
  
  def create
    @question = Question.new(question_params)
    
    if @question.save
      flash[:success] = "Your question successfully created."
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render :new
    end
  end
  
  def update
    if @question.update(question_params)
      flash[:success] = "Your question has been updated successfully."
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    @question.destroy
    flash[:success] = "Your question has been successfully deleted!"
    redirect_to questions_path
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
