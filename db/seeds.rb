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
User.create(email: 'admin@qna.com', password: 'pa$$w0rd', password_confirmation: 'pa$$w0rd', admin: true)

10.times do |n|
  User.create!(email: Faker::Internet.email,
               password: 'password',
               password_confirmation: 'password')
end

# Questions
users = User.order(:created_at).take(5)
users.each do |user| 
  rand(1..5).times do |n|
    title = Faker::Lorem.sentence(5)
    body_question = Faker::Lorem.paragraph(10)
    
    question = user.questions.create!(title: title, body: body_question)
    
    # Answers
    rand(1..5).times do |m|
      body_answer = Faker::Lorem.paragraph(10)
      best = Faker::Boolean.boolean
      question.answers.create!(body: body_answer, best: best, user: user)
    end
  end
end
