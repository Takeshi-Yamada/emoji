class QuestionRankingQuery
  def call
    Question
      .active
      .left_joins(:answers)
      .where(answers: { is_result: true })
      .group(:id)
      .select("questions.*, COUNT(answers.id) AS correct_answers_count")
      .order("correct_answers_count DESC")
      .limit(10)
  end
end
