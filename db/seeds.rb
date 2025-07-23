# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.new(name: 'writer', email: 'test@example.com', password: 'hogehoge')
user.save

#  {content: '',correct: '', :user_id => user.id},
question = Question.create!([
  { content: '🎥🦖🛝', correct: 'ジュラシックパーク', user_id: user.id },
  { content: '💳🌸🐶🐶🐶', correct: 'カードキャプターさくら', user_id: user.id },
  { content: '🏴‍☠️👒🩴☀️🐑', correct: 'ワンピース', user_id: user.id },
  { content: '📓🍎👿', correct: 'デスノート', user_id: user.id },
  { content: '🏇👧', correct: 'ウマ娘', user_id: user.id }
])
