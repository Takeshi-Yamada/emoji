require "emoji_regex"

class Question < ApplicationRecord
  validates :content, presence: true, length: {maximum: 6}
  validates :correct, presence: true, length: {maximum: 50}

  validate :content_must_be_emoji_only

  belongs_to :user

  has_many :answers

  private

  def content_must_be_emoji_only
    return if self.content.blank?

    regex = ::EmojiRegex::Regex
    matches = self.content.scan(regex).join

    if matches != self.content
      errors.add(:content, "は絵文字のみで入力してください")
    end
  end
end
