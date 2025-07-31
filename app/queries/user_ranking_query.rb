class UserRankingQuery
  def call
    User
      .left_joins(:answers)
      .where(answers: { is_result: true })
      .group(:id)
      .select('users.*, COUNT(answers.id) AS correct_answers_count')
      .order('correct_answers_count DESC')
      .limit(10)
  end
end
