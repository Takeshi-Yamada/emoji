class Question < ApplicationRecord
  validates :content, presence: true
  validates :content, format: { with: /\A(?:\p{Emoji_Presentation}|\p{Extended_Pictographic}|\p{Emoji})+\z/, message: "は絵文字のみで入力してください" }

  belongs_to :user

  has_many :answers
end
