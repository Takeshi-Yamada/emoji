class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_many :questions
  has_many :answers
  has_many :give_ups
  has_many :given_up_questions, through: :give_ups, source: :question

  def self.u_ranking
    UserRankingQuery.new.call
  end
end
