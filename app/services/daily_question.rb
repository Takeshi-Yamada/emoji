class DailyQuestion
  def self.today_question
    # 当日0時までの問題だけを抽出
    target_scope = Question.where("created_at < ?", Date.today.beginning_of_day)
    total_questions = target_scope.count
    return nil if total_questions == 0     # ← クイズが1問もないときはnilで返すようガード

    index = Zlib.crc32(Date.today.to_s) % total_questions # 与えた文字列(今回は日付)を32bit数値に変換するハッシュ関数
    target_scope.offset(index).first
  end
end
