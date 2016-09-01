class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    respond_to do |format|
      if @answer.save
        format.html { render partial: @answer, layout: false }
        format.json { render json: @answer }
      else
        format.html { render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user.author_of?(@answer) 
      @answer.update(answer_params)
      flash[:notice] = 'Answer updated'
    else
      flash[:error] = 'You cannot change answers written by others!'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer deleted'
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
  end
end
