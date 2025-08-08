class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable,
         omniauth_providers: [ :google_oauth2 ]

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  has_many :questions
  has_many :answers
  has_many :give_ups
  has_many :given_up_questions, through: :give_ups, source: :question
  has_many :login_histories

  def self.u_ranking
    UserRankingQuery.new.call
  end

  def self.from_omniauth(auth)
    # ケース1：既にGoogle連携済みのユーザー（最も多いケース）
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # ケース2：メールアドレスは登録済みだが、Google連携は初めてのユーザー
    user = find_by(email: auth.info.email)
    if user
      # 安全装置：他のSNSで連携済みでないか確認してから、情報を紐づける
      if user.provider.blank?
        user.update(
          provider: auth.provider,
          uid: auth.uid,
          name: user.name || auth.info.name.presence # 既存の名前を上書きしない配慮
        )
      end
      return user
    end

    # ケース3：全くの新規ユーザー
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name.presence || auth.info.email.split("@").first
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end
end
