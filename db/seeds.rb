# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Subscription.delete_all
Comment.delete_all
Authorization.delete_all
Vote.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

USER_COUNT = 15
QUESTION_COUNT = 30
ANSWER_COUNT = 10
COMMENT_COUNT = 3
ATTACHMENT_COUNT = 3

# Users
USER_COUNT.times do |n|
  user = User.create!(email: Faker::Internet.email,
                       password: 'password',
                       password_confirmation: 'password',
                       confirmed_at: Time.zone.now)
end

# Questions
QUESTION_COUNT.times do |n|
  title = Faker::Lorem.sentence(5)
  body_question = Faker::Lorem.paragraph(10)
  
  question = Question.create!(user: User.all[rand(User.count)], title: title, body: body_question)
  
  # Answers
  rand(0..ANSWER_COUNT).times do |n|
    body_answer = Faker::Lorem.paragraph(10)
    
    answer = question.answers.create!(body: body_answer, user: User.all[rand(User.count)])

    # Comments
    rand(0..COMMENT_COUNT).times do |n|
      body_comment = Faker::Lorem.paragraph(1)
      
      answer.comments.create!(body: body_comment, user: User.all[rand(User.count)])
    end
  end

  # Comments
  rand(0..COMMENT_COUNT).times do |n|
    body_comment = Faker::Lorem.paragraph(1)
    
    question.comments.create!(body: body_comment, user: User.all[rand(User.count)])
  end
end

User.create(email: 'admin@qna.com', password: 'pa$$w0rd', password_confirmation: 'pa$$w0rd', admin: true, confirmed_at: Time.zone.now )
