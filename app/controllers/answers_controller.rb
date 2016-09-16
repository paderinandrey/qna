class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]

  include Voted
  
  def create
      @question = Question.find(params[:question_id])
      @answer = @question.answers.build(answer_params.merge(user: current_user))
      respond_to do |format|
        if @answer.save
          format.js do
            PrivatePub.publish_to "/questions/#{ @question.id }/answers", answer: @answer.to_json
            head :ok
          end
        else
          format.js
        end
      end
  end

  def update
    if current_user.author_of?(@answer) 
      respond_to do |format|
        @answer.update(answer_params)
        #flash[:notice] = 'Answer updated'
        format.js do
        PrivatePub.publish_to "/questions/#{ @answer.question_id }/answers", answer: @answer.to_json(only: [:id, :body]), method: :update
        head :ok
        end
      end
    else
      flash[:error] = 'You cannot change answers written by others!'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_to do |format|
      @answer.destroy
        #flash[:notice] = 'Answer deleted'
        format.js do
          PrivatePub.publish_to "/questions/#{ @answer.question_id }/answers", answer: @answer.to_json(only: :id), method: :delete
          head :ok
        end
      end
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
