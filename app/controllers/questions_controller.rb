class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.order(best: :desc)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:success] = "Your question successfully created."
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:success] = "Your question has been updated successfully."
        redirect_to @question
      else
        flash[:error] = @question.errors.full_messages
        render :edit
      end
    else
      flash[:error] = "You cannot edit questions written by others."
      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = "Your question has been successfully deleted!"
      redirect_to questions_path
    else
      flash[:error] = "You cannot delete questions written by others."
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
