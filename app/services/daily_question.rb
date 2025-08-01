class DailyQuestion
  def self.today_question
    seed = Date.today.to_s
    total = Question.count
    return nil if total == 0     # ← クイズが1問もないときはnilで返すようガード

    index = Zlib.crc32(seed) % total # 与えた文字列(今回は日付)を32bit数値に変換するハッシュ関数
    Question.offset(index).first
  end
end