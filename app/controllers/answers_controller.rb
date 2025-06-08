class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    @answers = current_user.answers.find(params[:id])
  end

  def create
    @quetion = Question.find(params[:question_id])
    @answer = current_user.answers.build(question: @question, body: answer_params, result: normalize(@question.answer) == normalize(answer_params))
    if @answer.save
      redirect_to @question, notice: @answer.result ? "🎉 正解！" : "😢 不正解でした"
    else
      flash.now[:alert] = "回答にエラーがあります"
      render "questions/show"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def normalize(text)
    text.to_s.gsub(/[\s　]+/, "").downcase.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end
end
