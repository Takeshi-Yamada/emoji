FactoryBot.define do
  factory :question do
    content { '📓🖊️💀😈🍎' }
    correct { 'デスノート' }
    hint_1 { '死神はリンゴが好き' }
    hint_2 { 'ノートに名前を書かれた人は死ぬ' }
    hint_3 { '新世界の神になる' }
  end
end
