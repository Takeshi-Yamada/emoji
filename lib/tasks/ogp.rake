namespace :ogp do
  desc "既存の全クイズに対してOGP画像を生成"
  task generate_all: :environment do
    Question.find_each do |question|
      path = Rails.root.join("public/ogp_images/question_#{question.id}.png")
      puts "Generating OGP for question ##{question.id}"
      OgpCreator.generate(question)
    end
    puts "Done!"
  end
end
