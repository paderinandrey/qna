class AddAssociationsForQuestionsAndAnswersToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user, index: true, foreign_key: {to_table: :users}
    add_reference :answers, :user, index: true, foreign_key: {to_table: :users}
  end
end
