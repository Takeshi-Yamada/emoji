require "emoji_regex"

class Question < ApplicationRecord
  validates :content, presence: true
  validates :correct, presence: true, length: {maximum: 50}
  validates :hint_1, :hint_2, :hint_3, length: { maximum: 255 }, allow_blank: true

  validate :content_must_be_emoji_only
  validate :content_max
  validate :hints_order_validation

  enum :answer_category, { undefined: 0, japanese: 1, english: 2, both: 3 }
  before_save :set_answer_category

  acts_as_taggable_on :tags
  belongs_to :user
  has_many :answers
  has_many :give_ups
  has_many :users_gave_up, through: :give_ups, source: :user

  def self.ransackable_attributes(auth_object = nil)
    %w[
      content
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["tags", "taggings"]
  end

  private

  def content_must_be_emoji_only
    return if self.content.blank?

    regex = ::EmojiRegex::Regex
    matches = self.content.scan(regex).join

    if matches != self.content
      errors.add(:content, "は絵文字のみで入力してください")
    end
  end

  def content_max
    if self.content.each_grapheme_cluster.count > 6
      errors.add(:content, "絵文字は6個以内で入力してください")
    end
    p self.content.each_grapheme_cluster.count
  end

  def set_answer_category
    text = self.correct.to_s

    has_japanese = text.match?(/[\p{Hiragana}\p{Katakana}\p{Han}ー]/)
    has_english  = text.match?(/[a-zA-Z]/)

    self.answer_category =
      if has_japanese && has_english
        :both
      elsif has_japanese
        :japanese
      elsif has_english
        :english
      else
        :undefined
      end
  end

  def hints_order_validation
    if hint_2.present? && hint_1.blank?
      errors.add(:hint_2, "を入力するには、先にヒント1を入力してください")
    end

    if hint_3.present? && hint_2.blank?
      errors.add(:hint_3, "を入力するには、先にヒント2を入力してください")
    end
  end
end
