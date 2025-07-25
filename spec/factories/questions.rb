FactoryBot.define do
  factory :question do
    # 絵文字はモノによっては文字数がブレるので変更しないこと
    content { '🧠🚀🎯🐱🍙' }
    correct { 'デスノート' }
    hint_1 { '死神はリンゴが好き' }
    hint_2 { 'ノートに名前を書かれた人は死ぬ' }
    hint_3 { '新世界の神になる' }
    association :user
  end
end
