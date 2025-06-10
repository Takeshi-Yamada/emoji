class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    @answers = current_user.answers.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.build(question: @question, body: answer_params[:body], result: normalize(@question.correct) == normalize(answer_params[:body]))
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
    text.to_s.gsub(/[\s　]+/, "").downcase.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').tr('ァ-ン', 'ぁ-ん')
  end
end
